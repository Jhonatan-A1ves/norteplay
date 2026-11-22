# RBAC e RLS

## Escopo

O RBAC desta primeira migration é somente **global da plataforma**. Ele define quem pode administrar papéis e atribuições da plataforma. A permissão `platform.servers.*` ou um papel global de operador não deve ser usado para dar acesso indiscriminado a vários servidores.

Antes de ativar gestão multi-servidor, aprovar `server_memberships` ou `server_user_roles` com `server_id`, papéis limitados ao servidor e políticas que validem esse escopo. A primeira migration não cria essa associação.

## Permissões iniciais

| Permissão               | Uso                                                                   |
| ----------------------- | --------------------------------------------------------------------- |
| `platform.rbac.read`    | Consultar catálogo e relações de papéis/permissões                    |
| `platform.rbac.manage`  | Capacidade a verificar no backend para gestão futura do catálogo RBAC |
| `platform.users.read`   | Consultar atribuições de outros usuários                              |
| `platform.users.manage` | Capacidade a verificar no backend antes de atribuir/revogar papéis    |
| `platform.audit.read`   | Consultar histórico de atribuições e revogações                       |

O papel `platform_owner` recebe essas permissões, mas a migration não atribui esse papel a nenhum usuário. Não há promoção automática no cadastro.

## Matriz de acesso

| Recurso                                              | `anon`     | `authenticated`                                    | Backend administrativo                            |
| ---------------------------------------------------- | ---------- | -------------------------------------------------- | ------------------------------------------------- |
| Catálogos `roles`, `permissions`, `role_permissions` | Sem acesso | Leitura                                            | Leitura                                           |
| Atribuições `user_roles`                             | Sem acesso | Próprias; outras somente com `platform.users.read` | Leitura e criação; revogação sem apagar histórico |
| Histórico `platform_role_audit`                      | Sem acesso | Somente com `platform.audit.read`                  | Leitura justificada                               |
| Escrita direta pelo navegador                        | Negada     | Negada                                             | Não se aplica                                     |

RLS está habilitada em todas as tabelas. A função `has_platform_permission` é `SECURITY DEFINER`, usa `search_path` vazio e nomes totalmente qualificados; ela consulta somente a associação do `auth.uid()` atual e as atribuições ativas. A execução é concedida somente ao papel `authenticated`.

O backend deve primeiro verificar a permissão no contexto JWT do usuário. Operações internas de concessão/revogação podem então usar um cliente administrativo isolado; esse cliente ignora RLS e deve copiar o `auth.uid()` validado para `assigned_by`/`revoked_by`. A chave privilegiada nunca chega ao navegador ou ao agente. Não conceder escritas RBAC ao cliente associado ao JWT.

## Auditoria e bootstrap

`user_roles` guarda o estado atual/histórico da atribuição, com `assigned_at`, `assigned_by`, `revoked_at` e `revoked_by`. Um trigger grava `role_assigned` e `role_revoked` em `platform_role_audit`, que não tem FKs para manter o registro se usuário ou papel forem removidos. Não conceder `UPDATE` ou `DELETE` nesse histórico a `anon`, `authenticated` ou `service_role`.

O bootstrap inicial do `platform_owner` exige uma operação controlada após confirmar a conta em `auth.users`. O procedimento deve receber o UUID verificado do usuário e registrar o ator; não oferecer endpoint público de autoatribuição. Esta etapa não executa o bootstrap no projeto remoto.

## Revisão pendente antes de expansão

Validar com o responsável a política de convite/remoção de usuários, a atribuição inicial de `platform_owner`, quem pode administrar papéis e o futuro modelo de membership por servidor antes de implementar módulos de domínio.
