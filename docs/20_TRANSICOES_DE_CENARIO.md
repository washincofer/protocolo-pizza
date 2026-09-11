# PROTOCOLO: PIZZA — Transições de Cenário

## Padrão oficial
As trocas de cenário deixam de ser cortes secos e passam a usar uma transição global.

### Áreas principais
- fade out: 0,18 s
- fade in: 0,18 s
- tela escurece
- ícone de pizza aparece no centro com pequena rotação/escala
- input fica bloqueado durante a troca

### Subáreas
- fade out: 0,10 s
- fade in: 0,12 s
- sem animação da pizza
- objetivo: parecer entrada/saída de um cômodo, sem quebrar o ritmo

## Arquitetura
- `godot/scripts/scene_transition.gd`: controla animação, overlay e bloqueio de clique
- `godot/scripts/scene_router.gd`: toda troca de área passa por `SceneTransition`
- `godot/scripts/interaction_guard.gd`: bloqueia movimento e input enquanto `SceneTransition.is_transitioning()` estiver ativo
- `godot/project.godot`: `SceneTransition` é Autoload

## Novo Jogo
Mesmo que `GameState.current_area` já esteja em `reception`, se o menu principal estiver visível a entrada em Novo Jogo ainda executa o fade e a animação da pizza.

## Música
A transição não altera trilhas. As músicas continuam sendo configuradas separadamente por área, conforme o polimento sala por sala.

## Direção futura
Se desejado, finais e retorno ao menu podem receber uma versão teatral mais longa usando o mesmo sistema, sem criar outra arquitetura paralela.
