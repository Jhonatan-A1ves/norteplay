# Ambiente de desenvolvimento

## Pré-requisitos

Node.js 24 LTS, pnpm 11, .NET 10 SDK para agente, Docker e Supabase CLI.

## Passos

1. Execute `pnpm install` na raiz.
2. Crie `.env.local` em `apps/web` e `.env` na raiz a partir do exemplo. Para ambiente local, configure a URL e publishable key informadas por `supabase start`; não use Secret Key no navegador.
3. Execute `supabase start`. O `supabase/config.toml` identifica o projeto remoto apenas pelo reference; iniciar local não modifica o remoto.
4. Rode `pnpm dev`; web em 3000 e API em 3001. Swagger fica em `/docs`; `GET /health` é a única rota da API nesta etapa.
5. Compile o agente com `dotnet build apps/agent/NortePlay.Agent.csproj`.

Para tipos após primeira migration, use `pnpm supabase:types` com Supabase local em execução. O arquivo gerado deve refletir schema validado; nenhum tipo de tabela foi presumido.
