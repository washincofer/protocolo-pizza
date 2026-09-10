# PROTOCOLO: PIZZA — Ajustes finos da UI piloto da Recepção

Data de calibração: 2026-09-10

## Balões de fala

A Recepção permanece como área piloto da nova UI de diálogo.

O deslocamento total adotado no piloto permanece em:

`+72 px em X` e `-58 px em Y`

Nesta rodada a arte do balão foi espelhada horizontalmente (`flip_h`) para reposicionar visualmente a ponta sem alterar o texto.

O conteúdo textual dos balões permanece centralizado:

- alinhamento horizontal central;
- alinhamento vertical central;
- `VBoxContainer` centralizado;
- área de texto expandida dentro do espaço útil do balão.

## Ícones de Troféu e Menu

Após o teste em tela, os ícones ainda apareciam grandes e muito próximos da borda direita. A nova calibração reduz novamente o tamanho e move os dois controles mais para dentro da tela.

Parâmetros atuais:

- largura visual máxima: `6 px`;
- área clicável: `24 × 24 px`;
- margem direita: `36 px`;
- espaço entre Troféu e Menu: `6 px`;
- posição vertical: `10 px`;
- `expand_icon = true` para impedir que o tamanho original do PNG aumente o botão;
- `clip_contents = true` para impedir vazamento visual para fora da área clicável;
- botões sem moldura visível (`flat`).

## HUD de escolhas A/B/C/D

O painel visual de escolhas permanece com a disposição:

`A | B`

`C | D`

Após a revisão visual por screenshot, o painel ainda estava grande demais. A escala atual passa a ser:

`0.16`

O painel continua centralizado horizontalmente e preso à região inferior da tela.

## Regra futura aprovada — Troféus

Assim que o tamanho e a apresentação do ícone de Troféu forem aprovados na HUD principal, **o mesmo ícone deve ser reutilizado como padrão visual na interface/lista de troféus e conquistas conquistadas**.

Não criar uma segunda identidade visual de troféu para a tela de conquistas; reutilizar o asset aprovado em:

`godot/assets/ui/icons/trophy.png`

## Implementação

Os ajustes deste piloto ficam centralizados em:

`godot/scripts/ui_fine_tune.gd`

Isso permite calibrar rapidamente posição e escala sem alterar a lógica principal já validada da Recepção.
