# Contribuindo

## Branches e promoção

- `main`: produção; não desenvolver diretamente.
- `develop`: integração.
- Crie branches temporárias a partir de `develop`, abra PR para `develop` e aguarde revisão/CI.
- Promova `develop` para `main` apenas por PR aprovado e validado. Não use force push nem reescreva histórico.

O workspace foi entregue sem repositório Git e a rede não resolveu `github.com`, então branches remotas e proteções não puderam ser verificadas nem configuradas. O repositório local agora está em `develop`, sem commits, e `origin` aponta para o URL informado. Depois de confirmar acesso ao GitHub:

1. Verifique o estado remoto antes de publicar. Se já houver histórico, faça `git fetch origin --prune` e crie/atualize `develop` a partir de `origin/main`, preservando o histórico.
2. Publique o bootstrap em `develop` após configurar a identidade Git do responsável e revisar os arquivos.
3. No GitHub, defina `main` como default branch. Crie `develop` a partir de `main` se ainda não existir.
4. Em `Settings > Rules` (ou branch protection), exija PR e status checks aprovados em `main` e `develop`, bloqueie force push e deleção. Em `main`, exija aprovação de revisão antes do merge.

Se o remoto estiver vazio, crie e publique primeiro um commit inicial na `main`, defina-a como padrão e então publique `develop`. Não force push em nenhum caso.

## Alterações

- Mantenha segredos fora do Git e valide `.env*` antes do commit.
- Mudanças de schema devem ser migrations SQL aditivas e revisadas; nunca aplicar diretamente ao projeto remoto sem aprovação.
- Não afirmar suporte operacional que não esteja implementado e testado.
- Atualize documentação e contratos junto das alterações de domínio.
- Execute lint, typecheck, testes e builds dos componentes afetados antes de abrir PR.
