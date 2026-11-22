# Comunicação API e agente

O Windows Agent deverá iniciar uma conexão autenticada de saída para a API por HTTPS/WSS. Não expor porta de entrada no Windows e não publicar RCON na internet.

## Contrato futuro

1. Provisionar identidade única do agente, vinculada a um único servidor.
2. Autenticar com segredo curto ou certificado próprio, armazenamento protegido pelo sistema operacional, rotação e revogação.
3. Enviar heartbeat sequenciado e eventos identificados; persistir localmente eventos até confirmação durável da API.
4. Receber comandos persistidos, autorizados para aquele servidor, com UUID, sequência monotônica, expiração e chave idempotente.
5. Validar assinatura/credencial, servidor, sequência, prazo e replay antes de executar; confirmar estados accepted/running/succeeded/failed/rejected.
6. Auditar solicitante, autorização, payload redigido, resultado e timestamps.

Supabase Realtime não é fila confiável de comandos. A execução exige armazenamento durável, retry limitado, idempotência e confirmação. Nenhuma dessas operações está implementada nesta fundação; os schemas compartilhados são apenas contratos de dados.
