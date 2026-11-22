# Modelo conceitual de dados

Este modelo foi revisado para a primeira etapa de autorização. A migration inicial proposta contém somente o catálogo RBAC global e as atribuições globais de plataforma; os demais domínios seguem conceituais.

## Identidade e autorização

- `auth.users` do Supabase é a fonte canônica de identidade. Não duplicar essa tabela como `public.users`.
- `profiles` poderá guardar preferências e dados de apresentação quando os requisitos estiverem definidos; não é necessário para autorização e fica fora da primeira migration.
- `roles` e `permissions` descrevem papéis e capacidades globais da plataforma. `role_permissions` relaciona os dois.
- `user_roles` associa usuários Auth a papéis globais. A primeira migration mantém atribuições e revogações com ator e horário; `platform_role_audit` é append-only.
- Papéis globais não concedem automaticamente acesso a todos os servidores. Antes de operar vários servidores independentes, definir uma associação com escopo por servidor, como `server_memberships`/`server_user_roles`, e políticas RLS correspondentes.

## Domínios futuros

- `servers` tem vários `server_agents`, `server_profiles`, `server_configurations`, `server_plugins`, `server_commands` e `server_events`.
- `players` usa UUID interno e SteamID64 único como identificador externo. `teams` conecta jogadores por `team_members`.
- `matches` referencia servidor e perfil; `match_players`, `match_maps`, `match_events`, `match_rounds` e `match_results` mantêm composição e histórico.
- `mix_rooms` referencia servidor e partida; `mix_queue` associa jogadores às filas.
- `player_statistics` agrega métricas por jogador e período; `demos` armazena metadados e uma referência a artefatos fora do Git.
- `notifications` referencia usuários; `audit_logs` registra ator, ação e alvo sem armazenar segredos.

## Integridade, índices e retenção

Use UUID como PK e FKs explícitas. Para jogadores, use uma restrição única em SteamID64. Para comandos, use chave de idempotência única por servidor. Indexe FKs e consultas previstas, por exemplo `server_id + created_at`, `match_id`, SteamID64 e filas por status/prioridade. Avalie particionamento de eventos/auditoria somente após volume medido. Defina retenção por classe de dados, expurgo auditável e política separada para demos volumosas antes de implementar esses domínios.

## Limites desta etapa

Não há perfis de jogador, servidores, partidas ou estatísticas na migration proposta. A associação global `user_roles` não substitui a autorização por servidor. A primeira atribuição de `platform_owner` não será automática: exige provisionamento explícito e controlado depois da criação/verificação do usuário Auth.
