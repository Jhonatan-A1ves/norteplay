# Contribuindo

## Branches e promoção

- `main`: produção; não desenvolver diretamente.
- `develop`: integração.
- Crie branches temporárias a partir de `develop`, abra PR para `develop` e aguarde revisão/CI.
- Promova `develop` para `main` apenas por PR aprovado e validado. Não use force push nem reescreva histórico.

O workspace local tem as branches `develop` e `main`, com o commit inicial do bootstrap em ambas, e `origin` aponta para o URL informado. Não foi possível confirmar o conteúdo remoto: uma consulta não listou refs e outra falhou por DNS. Antes de publicar, confira as branches no GitHub e rode `git ls-remote --heads origin` novamente. Não presuma que o remoto está vazio se a consulta falhar.

1. Se o remoto tiver histórico, faça `git fetch origin --prune`, revise os commits e reconcilie as branches sem apagar histórico.
2. Se confirmar que o remoto está realmente vazio, publique o bootstrap local em `main` e `develop` sem force push.
3. No GitHub, defina `main` como default branch.
4. Em `Settings > Rules` (ou branch protection), exija PR e status checks aprovados em `main` e `develop`, bloqueie force push e deleção. Em `main`, exija aprovação de revisão antes do merge.

Não force push em nenhum caso.

## Alterações

- Mantenha segredos fora do Git e valide `.env*` antes do commit.
- Mudanças de schema devem ser migrations SQL aditivas e revisadas; nunca aplicar diretamente ao projeto remoto sem aprovação.
- Não afirmar suporte operacional que não esteja implementado e testado.
- Atualize documentação e contratos junto das alterações de domínio.
- Execute lint, typecheck, testes e builds dos componentes afetados antes de abrir PR.
