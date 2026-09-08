# Migração Godot — Production Base 0.1

## Marco

Com o protótipo HTML completo aprovado, o projeto entra oficialmente na fase de **migração/produção em Godot**.

## Entregue nesta passagem

- menu inicial funcional;
- Novo Jogo;
- Save / Load com três slots;
- Opções persistentes;
- `GameState` central;
- `AchievementManager`;
- `EndingManager`;
- `SettingsManager`;
- `SaveManager`;
- `SceneRouter`;
- `GameFlow`;
- catálogo data-driven das áreas;
- rota canônica jogável completa;
- branch Hall → Financeiro / Engenharia;
- requisitos principais dos cinco chefes;
- avaliação final da pizza;
- integração dos cenários por caminho de asset.

## O que esta build ainda não representa

Esta base não substitui o jogo final. As interações ainda aparecem como botões contextuais sobre o cenário. O próximo passo é transformar essas ações em hotspots físicos e navegação point-and-click.

## Próxima passagem de produção

1. corrigir todo branding visual para **PAPO SAPÃO**;
2. criar cena-base point-and-click reutilizável;
3. implementar protagonista clicando/caminhando até hotspots;
4. separar Recepção, Auditório e Sala de Espera em subcenas;
5. migrar os diálogos completos do protótipo aprovado;
6. implementar ações incorretas e finais alternativos;
7. ligar as 22 conquistas às condições exatas;
8. implementar inventário visual e uso item → alvo;
9. implementar efeitos de `PROCESSO CONTORNADO`;
10. adicionar áudio, vinhetas e feedback contextual;
11. executar playtest e regressão de save/load em toda a campanha.

## Regra de escopo

A rota narrativa, elenco, empresa, finais e conquistas permanecem fechados. A migração deve preservar esse cânone e alterar apenas implementação, ritmo, visual e polimento.
