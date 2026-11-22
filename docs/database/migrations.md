# Migrations

Use Supabase CLI e migrations SQL versionadas em `supabase/migrations`. Para desenvolvimento: `supabase start`, criar migration com `supabase migration new <nome>`, revisar SQL e aplicar somente no banco local com `supabase db reset`. Para validar, `supabase db lint --local --fail-on error`.

Não executar `supabase link`, `supabase db push` ou alterar projeto remoto sem autorização explícita. Migrations devem ser pequenas, aditivas, transacionais quando possível e acompanhadas de política RLS. Não incluir dados reais ou credenciais em seeds. `seed.sql` permanece vazio. `20261122000000_platform_rbac.sql` é a primeira migration de negócio proposta nesta etapa; aplique-a apenas no Supabase local durante validação e submeta-a a revisão antes de qualquer aplicação remota.
