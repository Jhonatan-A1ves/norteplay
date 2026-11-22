# Visão da arquitetura

## Componentes

```text
Navegador ── HTTPS ──> Next.js
     │                    │
     └── JWT ── HTTPS ───> NestJS API ──> Supabase/Postgres
                                      ▲
Windows Agent ── conexão iniciada de saída (planejada) ──┘
```

O monorepo contém `apps/web`, `apps/api`, `apps/agent` e `packages/shared`. Web e API são processos separados; o agente roda na máquina local do servidor CS2. A comunicação do agente não está implementada. O banco Supabase informado está reservado para este produto, mas nenhuma alteração remota foi realizada.

## Limites atuais

Web apresenta uma página informativa sem autenticação ou dados inventados. API tem documentação Swagger e health check, sem módulos de domínio. O agente compila como Worker Service e não inicia/paralisa processos de jogo. Os contratos compartilhados definem formas iniciais para identidade, heartbeat, comando, confirmação, evento, partida e perfis MIX/COMPETITIVE.

## Decisões

- Monorepo pnpm + Turborepo para compartilhar contratos e automação.
- UUID para identificadores internos; SteamID64 será identificador externo de jogador.
- Migrations revisadas e aditivas; nenhuma tabela de negócio antes da revisão do modelo.
- RLS é defesa em profundidade, não substitui autorização no backend.
