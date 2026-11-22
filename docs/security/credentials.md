# Credenciais e ambientes

- Frontend recebe `NEXT_PUBLIC_SUPABASE_URL` e `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY`. Publishable Key é pública por definição; habilite RLS antes de criar qualquer tabela.
- Backend recebe `SUPABASE_URL` e `SUPABASE_PUBLISHABLE_KEY` para operações de usuário vinculadas a JWT. `SUPABASE_SECRET_KEY` somente no ambiente confiável, em operações internas justificadas.
- Nunca prefixar Secret Key com `NEXT_PUBLIC_`, registrar em log, retornar por HTTP, colocar em documentação versionada ou fornecer ao Windows Agent.
- `.env.example` não contém valores secretos. Guardar arquivos reais fora do Git, limitar acesso e rotacionar imediatamente qualquer chave exposta.
- Não colar chaves no chat. Configurar diretamente no ambiente local ou no gestor de segredos de hospedagem.

O agente deverá usar identidade e credenciais próprias, não chaves Supabase.
