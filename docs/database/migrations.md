# Migrations

Use Supabase CLI e migrations SQL versionadas em `supabase/migrations`. Para desenvolvimento: `supabase start`, criar migration com `supabase migration new <nome>`, revisar SQL e aplicar somente no banco local com `supabase db reset`. Para validar, `supabase db lint` quando suportado pela versão instalada.

Não executar `supabase link`, `supabase db push` ou alterar projeto remoto sem autorização explícita. Migrations devem ser pequenas, aditivas, transacionais quando possível e acompanhadas de política RLS. Não incluir dados reais ou credenciais em seeds. O `seed.sql` atual é intencionalmente vazio e não há migrations de negócio.
