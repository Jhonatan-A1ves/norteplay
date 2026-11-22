# Modelo conceitual de dados

O esquema abaixo é uma proposta para revisão; não existe migration de negócio ainda.

## Entidades e relações

- `users` relaciona identidade Supabase Auth a perfil; `roles`, `permissions` e `user_roles` modelam RBAC. Uma role reúne permissões e usuário pode ter várias roles.
- `servers` possui vários `server_agents`, `server_profiles`, `server_configurations`, `server_plugins`, `server_commands` e `server_events`.
- `players` usa UUID interno e SteamID64 único como identificador externo. `teams` conecta jogadores por `team_members`.
- `matches` referencia servidor e perfil; `match_players`, `match_maps`, `match_events`, `match_rounds` e `match_results` mantêm composição e histórico.
- `mix_rooms` referencia servidor e partida; `mix_queue` associa jogadores às filas.
- `player_statistics` agrega métricas por jogador e período; `demos` aponta metadados e localização de artefatos fora do Git.
- `notifications` referencia usuários; `audit_logs` registra ator, ação e alvo sem guardar segredos.

## Integridade, índices e retenção previstos

Use UUID como PK, FKs explícitas, `NOT NULL` nos invariantes e restrições únicas para SteamID64, identidade ativa do agente e chaves de idempotência. Índices em FKs, `server_id + created_at`, `match_id`, SteamID64 e filas por status/prioridade. Avaliar particionamento de eventos/auditoria por tempo só após volume medido. Definir retenção por classe de dados, exportação/expurgo auditável e política própria para demos volumosas.

## RLS e autorização

Usuários comuns acessam somente recursos autorizados por membership/role. Agentes usam identidade própria e escopo de um servidor. Validar RBAC no backend; políticas RLS complementam esse controle. A Secret Key pode ignorar RLS e não pode ser usada como atalho para autorização.

Não criar as tabelas até revisão do domínio, políticas de retenção e matriz RBAC.
