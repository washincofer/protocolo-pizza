# HUD de Finais e Conquistas

## Objetivo
Padronizar a tela exibida quando uma partida termina e transformar os finais absurdos em uma recompensa visual coerente com a identidade de PROTOCOLO: PIZZA.

## Comportamento
- Todo final não canônico usa o selo **FINAL ABSURDO**.
- O final `ENTREGA CONCLUÍDA` usa o selo **MISSÃO CUMPRIDA**.
- A tela mostra o nome do final, a descrição, a quantidade de finais descobertos e o progresso das conquistas.
- Quando o mesmo evento do final desbloqueia uma conquista nova, a tela exibe o troféu oficial e um cartão **CONQUISTA DESBLOQUEADA**.
- Se duas conquistas forem liberadas no mesmo evento, como a conquista comum mais `100% Conforme`, ambas são mostradas.
- Quando não há conquista nova naquele final, aparece o cartão **FINAL REGISTRADO NO ARQUIVO DA PAPO SAPÃO**.

## Botões
- `Nova partida`
- `Ver conquistas`
- `Menu principal`

## Segurança técnica
A implementação está isolada em `godot/scripts/ending_ui.gd`, carregada como Autoload `EndingUI`.

Ela não altera:
- SceneRouter;
- PlayerController;
- FloorInputFix;
- InteractionGuard;
- hotspots;
- troca de áreas.

A UI é exibida somente após o sinal `GameFlow.finished` e usa um CanvasLayer acima da tela final antiga. A tela de Conquistas permanece acima dela.

## Sala de Espera
O hotspot `Visitantes esperando` mantém três falas individuais com balões posicionados sobre as três pessoas do sofá.

Fluxo:
1. primeiro clique: Visitante 1;
2. segundo clique: Visitante 2;
3. terceiro clique: Visitante 3;
4. quarto clique: final `VISITANTE RETIRADO`.

Texto do final:
> Você esperou tanto que virou parte do mobiliário. A segurança resolveu o problema.
