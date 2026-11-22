begin;

create table public.roles (
  id uuid primary key default gen_random_uuid(),
  role_key text not null unique,
  display_name text not null,
  description text,
  created_at timestamptz not null default now(),
  constraint roles_role_key_format check (role_key ~ '^[a-z][a-z0-9_]{1,62}$')
);

create table public.permissions (
  id uuid primary key default gen_random_uuid(),
  permission_key text not null unique,
  description text not null,
  created_at timestamptz not null default now(),
  constraint permissions_platform_key_format check (
    permission_key ~ '^platform\.[a-z][a-z0-9_]*(\.[a-z][a-z0-9_]*)*$'
  )
);

create table public.role_permissions (
  role_id uuid not null references public.roles (id) on delete cascade,
  permission_id uuid not null references public.permissions (id) on delete restrict,
  created_at timestamptz not null default now(),
  primary key (role_id, permission_id)
);

create index role_permissions_permission_id_idx
  on public.role_permissions (permission_id);

create table public.user_roles (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  role_id uuid not null references public.roles (id) on delete restrict,
  assigned_at timestamptz not null default now(),
  assigned_by uuid not null,
  revoked_at timestamptz,
  revoked_by uuid,
  constraint user_roles_revocation_actor_pair check (
    (revoked_at is null and revoked_by is null)
    or (revoked_at is not null and revoked_by is not null)
  ),
  constraint user_roles_revoked_after_assignment check (
    revoked_at is null or revoked_at >= assigned_at
  )
);

create unique index user_roles_one_active_assignment_idx
  on public.user_roles (user_id, role_id)
  where revoked_at is null;

create index user_roles_active_role_idx
  on public.user_roles (role_id, user_id)
  where revoked_at is null;

create index user_roles_history_user_idx
  on public.user_roles (user_id, assigned_at desc);

create table public.platform_role_audit (
  event_id uuid primary key default gen_random_uuid(),
  user_role_id uuid not null,
  subject_user_id uuid not null,
  role_id uuid not null,
  action text not null check (action in ('role_assigned', 'role_revoked')),
  actor_user_id uuid not null,
  occurred_at timestamptz not null default now()
);

create index platform_role_audit_subject_time_idx
  on public.platform_role_audit (subject_user_id, occurred_at desc);

create function public.has_platform_permission(p_permission_key text)
returns boolean
language sql
stable
security definer
set search_path = ''
as $function$
  select auth.uid() is not null
    and exists (
      select 1
      from public.user_roles as ur
      join public.role_permissions as rp on rp.role_id = ur.role_id
      join public.permissions as p on p.id = rp.permission_id
      where ur.user_id = (select auth.uid())
        and ur.revoked_at is null
        and p.permission_key = p_permission_key
    );
$function$;

comment on function public.has_platform_permission(text) is
  'Checks a global platform permission for the current authenticated JWT subject.';

revoke all on function public.has_platform_permission(text) from public, anon;
grant execute on function public.has_platform_permission(text) to authenticated;

create function public.guard_user_role_revocation()
returns trigger
language plpgsql
set search_path = ''
as $function$
begin
  if new.id is distinct from old.id
    or new.user_id is distinct from old.user_id
    or new.role_id is distinct from old.role_id
    or new.assigned_at is distinct from old.assigned_at
    or new.assigned_by is distinct from old.assigned_by then
    raise exception 'Role assignment identity and grant attribution are immutable';
  end if;

  if old.revoked_at is not null then
    raise exception 'A revoked role assignment cannot be changed or reactivated';
  end if;

  if new.revoked_at is null
    or new.revoked_by is null
    or new.revoked_at < old.assigned_at then
    raise exception 'Revocation requires a valid timestamp and actor';
  end if;

  return new;
end;
$function$;

revoke all on function public.guard_user_role_revocation() from public, anon, authenticated, service_role;

create function public.audit_user_role_change()
returns trigger
language plpgsql
security definer
set search_path = ''
as $function$
begin
  if tg_op = 'INSERT' then
    insert into public.platform_role_audit (
      user_role_id,
      subject_user_id,
      role_id,
      action,
      actor_user_id,
      occurred_at
    ) values (
      new.id,
      new.user_id,
      new.role_id,
      'role_assigned',
      new.assigned_by,
      new.assigned_at
    );
    return new;
  end if;

  if old.revoked_at is null and new.revoked_at is not null then
    insert into public.platform_role_audit (
      user_role_id,
      subject_user_id,
      role_id,
      action,
      actor_user_id,
      occurred_at
    ) values (
      new.id,
      new.user_id,
      new.role_id,
      'role_revoked',
      new.revoked_by,
      new.revoked_at
    );
  end if;

  return new;
end;
$function$;

revoke all on function public.audit_user_role_change() from public, anon, authenticated, service_role;

create trigger user_roles_guard_revocation
  before update on public.user_roles
  for each row execute function public.guard_user_role_revocation();

create trigger user_roles_write_audit
  after insert or update of revoked_at, revoked_by on public.user_roles
  for each row execute function public.audit_user_role_change();

alter table public.roles enable row level security;
alter table public.permissions enable row level security;
alter table public.role_permissions enable row level security;
alter table public.user_roles enable row level security;
alter table public.platform_role_audit enable row level security;

create policy roles_read_authenticated
  on public.roles for select to authenticated
  using (true);

create policy permissions_read_authenticated
  on public.permissions for select to authenticated
  using (true);

create policy role_permissions_read_authenticated
  on public.role_permissions for select to authenticated
  using (true);

create policy user_roles_read_own_or_privileged
  on public.user_roles for select to authenticated
  using (
    user_id = (select auth.uid())
    or public.has_platform_permission('platform.users.read')
  );

create policy platform_role_audit_read_privileged
  on public.platform_role_audit for select to authenticated
  using (public.has_platform_permission('platform.audit.read'));

revoke all on table
  public.roles,
  public.permissions,
  public.role_permissions,
  public.user_roles,
  public.platform_role_audit
from public, anon, authenticated, service_role;

grant usage on schema public to authenticated, service_role;
grant select on table
  public.roles,
  public.permissions,
  public.role_permissions,
  public.user_roles,
  public.platform_role_audit
to authenticated;

grant select on table
  public.roles,
  public.permissions,
  public.role_permissions,
  public.user_roles
to service_role;
grant insert on table public.user_roles to service_role;
grant update (revoked_at, revoked_by) on table public.user_roles to service_role;

insert into public.permissions (permission_key, description)
values
  ('platform.rbac.read', 'Read the global platform role and permission catalog'),
  ('platform.rbac.manage', 'Manage global platform role definitions and assignments'),
  ('platform.users.read', 'Read platform user role assignments'),
  ('platform.users.manage', 'Assign and revoke global platform roles'),
  ('platform.audit.read', 'Read platform role assignment audit history');

insert into public.roles (role_key, display_name, description)
values (
  'platform_owner',
  'Platform owner',
  'Initial global administrator role; user assignment requires an explicit bootstrap operation.'
);

insert into public.role_permissions (role_id, permission_id)
select r.id, p.id
from public.roles as r
join public.permissions as p on p.permission_key in (
  'platform.rbac.read',
  'platform.rbac.manage',
  'platform.users.read',
  'platform.users.manage',
  'platform.audit.read'
)
where r.role_key = 'platform_owner';

comment on table public.roles is
  'Global platform roles only; server-scoped memberships are a separate future domain.';
comment on table public.permissions is
  'Global platform permission catalog. Permission definitions are changed through reviewed migrations.';
comment on table public.user_roles is
  'Global platform role assignments. Revocation is recorded in-place and cannot be reversed.';
comment on table public.platform_role_audit is
  'Append-only role assignment and revocation history; identifiers intentionally have no foreign keys.';

commit;
