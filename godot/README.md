# Projeto Godot — Production Base 0.1

Primeira migração funcional do protótipo aprovado para Godot 4.

## Implementado nesta base

- tela inicial com **Novo Jogo**, **Save / Load** e **Opções**;
- 3 slots de save/load em `user://`;
- opções persistentes de volume geral, música, efeitos e tela cheia;
- autoloads separados: `GameState`, `AchievementManager`, `EndingManager`, `SettingsManager`, `SaveManager`, `SceneRouter` e `GameFlow`;
- rota canônica jogável da Recepção à Diretoria;
- Hall com Financeiro / Engenharia em qualquer ordem;
- estado da pizza: temperatura, integridade, quantidade, tempo e posse;
- catálogo persistente das 22 conquistas e dos finais;
- integração prevista para os cenários conceituais como backgrounds;
- fallback visual: se um background ainda não estiver no repositório, o projeto continua abrindo.

## Como abrir

1. Instale Godot 4.3+.
2. Importe `godot/project.godot`.
3. Execute o projeto.

## Importante sobre os cenários

Os PNGs da build estão sendo distribuídos junto do pacote ZIP de produção. O conector de escrita usado para atualizar o GitHub é textual, então os binários não foram gravados automaticamente no repositório nesta passagem.

Além disso, alguns cenários conceituais foram gerados antes do nome definitivo **PAPO SAPÃO** e ainda trazem marcações provisórias como “Pizza Sempre Chega S.A.”. Eles servem para montagem e teste, mas precisam de correção de branding antes do lock visual final.

## Próxima passagem

A próxima etapa transforma as ações de interface em point-and-click real: hotspots físicos, caminhada do protagonista, subáreas, diálogos completos e todos os finais alternativos.
