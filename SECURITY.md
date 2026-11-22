# Segurança

Reporte vulnerabilidades privadas ao responsável pelo repositório. Não publique detalhes exploráveis, tokens ou dados operacionais em issues.

## Controles estabelecidos

- Segredos não pertencem ao código ou frontend; `.env*` está ignorado, exceto `.env.example`.
- A CI inclui uma verificação de padrões de credenciais conhecida; ela não substitui um scanner abrangente.
- Nenhuma chave privilegiada foi adicionada.
- Não há endpoint de comandos nem transporte de agente implementado.

## Princípios para implementação futura

- Validar autorização de negócio no backend, inclusive antes de qualquer acesso administrativo Supabase.
- Operações em nome do usuário devem usar contexto JWT e RLS; acesso Secret Key fica restrito a fluxos internos justificados, pois pode ignorar RLS.
- O agente deve autenticar-se por credencial própria, vinculada a um servidor, revogável e rotacionável; nunca recebe chave Supabase.
- Não expor RCON, senhas ou credenciais administrativas ao navegador ou à internet.
- Registrar auditoria sem dados secretos, limitar privilégios e definir retenção.

Veja `docs/security/credentials.md` e `docs/architecture/agent-communication.md`.
