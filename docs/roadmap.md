# Roadmap

1. **Fundação:** monorepo, esqueleto web/API/agente, contratos, configuração Supabase local, CI e documentação (esta etapa).
2. **Revisão de domínio:** aprovar modelo relacional, RBAC, RLS, retenção e primeira migration.
3. **Identidade e API:** Supabase Auth, sessão JWT, autorização e módulos de usuários/servidores com testes.
4. **Canal de agente:** provisionamento, autenticação mútua, heartbeat, fila durável, confirmação e auditoria.
5. **Operações seguras:** inventário, status e comandos não destrutivos; teste controlado em ambiente local.
6. **Partidas e perfis:** MIX e competitivo, após segurança, observabilidade e recuperação estarem validadas.
7. **Hospedagem:** deploy web/API separado do Windows Agent e servidor CS2; rollout/rollback documentados. Não há deploy nesta etapa.
