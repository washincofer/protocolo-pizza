# PROTOCOLO: PIZZA — Protagonista jogável

O controlador `res://scripts/player_controller.gd` espera a spritesheet:

`res://assets/characters/protagonist_movement.png`

## Grade

- tamanho da imagem: 768 × 1920 px
- célula: 192 × 320 px
- 4 colunas × 6 linhas

### Linha 0 — Idle
- coluna 0: baixo/frente
- coluna 1: cima/costas
- coluna 2: esquerda
- coluna 3: direita

### Linha 1 — Walk Down
4 frames

### Linha 2 — Walk Up
4 frames

### Linha 3 — Walk Left
4 frames

### Linha 4 — Walk Right
4 frames

### Linha 5 — Carry Pizza
2 frames reservados para futura animação de interação/entrega.

## Controle atual

- clique no piso: protagonista caminha até o ponto
- clique em hotspot: protagonista caminha até um ponto próximo e só depois executa a ação
- escala varia pela profundidade para combinar com a perspectiva do cenário
- o personagem reaparece em um ponto de spawn ao trocar de área

A primeira calibração será feita na Recepção. Os pontos de aproximação específicos de cada hotspot poderão ser refinados depois usando F3.
