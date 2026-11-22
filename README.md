# NORTE PLAY — CS2 Server Manager

Monorepositório para a futura gestão de servidores Counter-Strike 2. Esta etapa entrega somente a fundação de engenharia: app web inicial, API de saúde/OpenAPI, contratos compartilhados, esqueleto de serviço Windows, configuração local Supabase e CI. Ainda não há integração autenticada, tabelas de negócio ou controle de servidor.

## Requisitos

- Node.js 24 LTS (mínimo 24.15) e pnpm 11;
- .NET 10 SDK para compilar o agente Windows;
- Docker e Supabase CLI para executar o Supabase localmente.

O projeto usa Node.js 24 LTS e .NET 10 LTS; valide patches suportados ao instalar ferramentas. Acesse a documentação oficial de [Node.js Releases](https://nodejs.org/en/about/previous-releases) e da [política .NET](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core).

## Estrutura

- `apps/web`: Next.js, React, TypeScript e Tailwind; a tela informa que a plataforma não está conectada;
- `apps/api`: NestJS REST com Swagger em `/docs` e health em `/health`;
- `apps/agent`: Worker Service .NET 10 hospedável como serviço do Windows; ainda sem transporte ou operações de jogo;
- `packages/shared`: schemas Zod e tipos de mensagens compartilhadas;
- `supabase`: configuração local, seed vazio e diretório de migrations sem tabelas de negócio;
- `docs`: arquitetura, segurança, banco, operação e roadmap.

## Desenvolvimento local

1. Copie `.env.example` para `.env.local` em `apps/web` e `.env` na raiz ou configure as variáveis no ambiente. Obtenha as chaves no painel Supabase; não as envie em chats nem as versione. A Publishable Key pode estar no navegador, protegida por RLS. A Secret Key só pode existir no backend confiável.
2. Instale dependências com `pnpm install`.
3. Inicie o Supabase local com `supabase start` quando a CLI e Docker estiverem instalados.
4. Rode `pnpm dev` para iniciar web e API.
5. Compile o agente com `dotnet build apps/agent/NortePlay.Agent.csproj` em uma máquina com SDK .NET 10.

Os valores `.env.example` incluem a URL pública do projeto informado. A configuração de desenvolvimento local deve apontar para o Supabase local conforme descrito em `docs/deployment/local-development.md`; não faça link/apply em projeto remoto durante esta etapa.

## Qualidade

`pnpm lint`, `pnpm typecheck`, `pnpm test`, `pnpm build`, `pnpm format:check`, `pnpm secrets:check` e `dotnet build apps/agent/NortePlay.Agent.csproj` são os comandos previstos. CI executa essas verificações para PRs e pushes em `develop` e `main`. Nenhum deploy está configurado.

## Git

O fluxo previsto é `main` para produção e `develop` para integração; mudanças normais entram por PR em `develop`, e promoção para `main` exige PR aprovado e CI verde. O remoto ainda não pôde ser consultado neste ambiente. Veja [CONTRIBUTING.md](CONTRIBUTING.md) para a configuração manual exigida.
