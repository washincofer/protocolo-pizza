# PROTOCOLO: PIZZA — Transição de Cenários

## Padrão global

As trocas de cenário não devem mais acontecer por corte seco.

### Áreas principais
- fade escuro curto;
- duração aproximada: 0,18 s para entrar + 0,18 s para sair;
- ícone da pizza aparece no centro com leve rotação/escala;
- interação e movimento ficam bloqueados durante a transição.

### Subáreas
- fade mais rápido e discreto;
- duração aproximada: 0,10 s para entrar + 0,12 s para sair;
- sem ícone de pizza, reforçando a sensação de que é apenas outro cômodo da mesma área.

## Arquitetura

- `godot/scripts/scene_transition.gd`
  - controla overlay, fade, animação e bloqueio visual;
  - identifica automaticamente transições envolvendo subáreas.

- `godot/scripts/scene_router.gd`
  - continua sendo o ponto único usado pela lógica do jogo;
  - agora solicita a animação antes de efetivar a mudança de `GameState.current_area`.

- `godot/scripts/interaction_guard.gd`
  - reconhece `SceneTransition.is_transitioning()`;
  - bloqueia PlayerController e FloorInputFix enquanto a animação estiver ativa.

## Objetivo de UX

A transição deve ser rápida o suficiente para não atrasar a exploração, mas perceptível o bastante para evitar cortes bruscos entre cenários.

## Ajustes futuros

Depois da calibração sala por sala, podem ser adicionados:
- sons próprios de porta/escada/elevador;
- textos curtos em trocas específicas de andar;
- transições especiais para finais e retorno ao menu;
- variações temáticas sem alterar o sistema base.
