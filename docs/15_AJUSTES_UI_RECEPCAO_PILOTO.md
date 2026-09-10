# PROTOCOLO: PIZZA — Ajustes finos da UI piloto da Recepção

Data de calibração: 2026-09-10

## Balões de fala

A Recepção permanece como área piloto da nova UI de diálogo.

A ponta do balão da recepcionista deve se aproximar da posição de imagem:

`X = 687, Y = 262`

Em relação à posição anterior usada no piloto, o deslocamento adotado é:

`+52 px em X` e `-58 px em Y`

Esse mesmo deslocamento deve ser aplicado aos demais balões da Recepção durante esta rodada de calibração.

## Ícones de Troféu e Menu

Os ícones da HUD no canto superior direito estavam visualmente grandes. Para o piloto, o tamanho visual foi reduzido em aproximadamente 80%, mantendo uma área de clique maior que o desenho para preservar usabilidade.

Parâmetros atuais:

- largura visual máxima do ícone: `10 px`
- área clicável: `32 × 32 px`
- botões sem moldura visível (`flat`)

## HUD de escolhas A/B/C/D

O painel visual de escolhas permanece com a disposição:

`A | B`

`C | D`

Para esta rodada, a escala visual do painel foi definida como:

`0.20` do tamanho anterior.

A implementação continua sendo piloto. Depois do teste visual, o valor pode ser refinado sem alterar a lógica dos diálogos.

## Regra futura aprovada — Troféus

Assim que o tamanho e a apresentação do ícone de Troféu forem aprovados na HUD principal, **o mesmo ícone deve ser reutilizado como padrão visual na interface/lista de troféus e conquistas conquistadas**.

Não criar uma segunda identidade visual de troféu para a tela de conquistas; reutilizar o asset aprovado em:

`godot/assets/ui/icons/trophy.png`

## Implementação

Os ajustes deste piloto ficam centralizados em:

`godot/scripts/ui_fine_tune.gd`

Isso permite calibrar rapidamente posição e escala sem alterar a lógica principal já validada da Recepção.
