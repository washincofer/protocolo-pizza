# PROTOCOLO: PIZZA — Cursor cartoon

Data: 2026-09-10

## Direção aprovada

O cursor do jogo passa a usar uma luva/cartoon com dois estados visuais:

- **estado neutro**: apenas contorno, interior transparente;
- **estado clicável**: mesma luva preenchida em tom claro, preservando contorno escuro.

A troca é automática conforme o tipo de cursor usado pelos controles do Godot:

- `CURSOR_ARROW` → cursor neutro;
- `CURSOR_POINTING_HAND` → cursor preenchido.

Os hotspots principais e de subáreas já usam `CURSOR_POINTING_HAND`, portanto recebem o estado preenchido ao passar o mouse sobre áreas clicáveis.

## Assets finais

- `godot/assets/ui/cursor/cursor_idle.png`
- `godot/assets/ui/cursor/cursor_active.png`

Ambos foram preparados em `64 × 64 px`, com fundo transparente.

## Implementação

O gerenciamento fica centralizado em:

`godot/scripts/cursor_manager.gd`

O script é carregado como Autoload através de:

`CursorManager="*res://scripts/cursor_manager.gd"`

Hotspot do cursor configurado em aproximadamente `Vector2(34, 2)`, alinhado à ponta do dedo indicador.

## Regra de UI

Sempre que um novo hotspot ou botão de interação do cenário for criado, usar:

`mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND`

Assim o cursor preenchido continua sendo o sinal visual padrão de que existe uma interação disponível.
