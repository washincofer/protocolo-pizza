# PROTOCOLO: PIZZA — Ajustes finos da UI piloto da Recepção

Data de calibração: 2026-09-10

## Balões de fala

A Recepção permanece como área piloto da nova UI de diálogo.

O deslocamento total adotado no piloto permanece em:

`+72 px em X` e `-58 px em Y`

Após o novo teste visual, o `flip_h` foi removido. A orientação original da arte volta a ser usada para que a ponta do balão fique do lado da recepcionista.

O conteúdo textual dos balões permanece centralizado:

- alinhamento horizontal central;
- alinhamento vertical central;
- `VBoxContainer` centralizado;
- área de texto expandida dentro do espaço útil do balão.

## Ícones de Troféu e Menu

Após o teste em tela, a posição dos ícones ficou correta, mas eles ficaram pequenos demais. Nesta rodada o tamanho foi aumentado levemente, preservando a margem que os mantém dentro da tela.

Parâmetros atuais:

- largura visual máxima: `9 px`;
- área clicável: `28 × 28 px`;
- margem direita: `36 px`;
- espaço entre Troféu e Menu: `8 px`;
- posição vertical: `10 px`;
- `expand_icon = true`;
- `clip_contents = true`;
- botões sem moldura visível (`flat`).

## HUD de escolhas A/B/C/D

O painel visual de escolhas permanece com a disposição:

`A | B`

`C | D`

A escala `0.16` ficou pequena demais no teste. Para a nova rodada, foi adotado um valor intermediário:

`0.28`

O painel continua centralizado horizontalmente e preso à região inferior da tela.

## Regra futura aprovada — Troféus

Assim que o tamanho e a apresentação do ícone de Troféu forem aprovados na HUD principal, **o mesmo ícone deve ser reutilizado como padrão visual na interface/lista de troféus e conquistas conquistadas**.

Não criar uma segunda identidade visual de troféu para a tela de conquistas; reutilizar o asset aprovado em:

`godot/assets/ui/icons/trophy.png`

## Implementação

Os ajustes deste piloto ficam centralizados em:

`godot/scripts/ui_fine_tune.gd`

Isso permite calibrar rapidamente posição e escala sem alterar a lógica principal já validada da Recepção.
