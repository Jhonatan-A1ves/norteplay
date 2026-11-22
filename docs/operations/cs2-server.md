# Operação futura do servidor CS2

O servidor CS2 ficará em máquina Windows local e será administrado pelo Windows Agent, sob conta de serviço de privilégio mínimo. A fundação não instala plugins, não controla processos, não executa comandos nem altera RCON.

Serão necessários inventário e associação explícita servidor/agente, health e consumo, fila offline local, política de atualização, backup de configurações, rollback, logs com retenção e procedimentos de revogação. Não abrir RCON à internet.

## Perfis previstos

- **MIX:** configurações flexíveis e cosméticos permitidos somente conforme compatibilidade aprovada; gerenciamento de salas, jogadores e equipes.
- **COMPETITIVE:** regras competitivas, modelos CT/T padrão, cosméticos desabilitados, mapas, veto, BO1/BO3/BO5, overtime, pausas e demos.

Troca deverá ser autenticada, validada contra perfil, auditada, serializada e reversível. Ainda não existe configuração operacional desses perfis.
