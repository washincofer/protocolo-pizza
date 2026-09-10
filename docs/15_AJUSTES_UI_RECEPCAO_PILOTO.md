# PROTOCOLO: PIZZA — Ajustes finos da UI piloto da Recepção

Data de calibração: 2026-09-10

## Balões de fala

A Recepção permanece como área piloto da nova UI de diálogo.

Após a nova rodada de teste, todos os balões foram deslocados mais 100 px para a direita no sistema de coordenadas da imagem.

O deslocamento total adotado no piloto passa a ser:

`+172 px em X` e `-58 px em Y`

A orientação original da arte permanece ativa, sem `flip_h`.

O conteúdo textual dos balões permanece centralizado e recebeu um ajuste vertical adicional:

- alinhamento horizontal central;
- alinhamento vertical central;
- `VBoxContainer` centralizado;
- área de texto expandida dentro do espaço útil do balão;
- bloco de texto deslocado `+6 px` em Y para baixo.

## Ícones de Troféu e Menu

A posição dos ícones permanece dentro da tela e a margem direita aprovada foi mantida. Como o teste anterior ainda ficou pequeno, o aumento anterior foi dobrado nesta rodada.

Parâmetros atuais:

- largura visual máxima: `15 px`;
- área clicável: `36 × 36 px`;
- margem direita: `36 px`;
- espaço entre Troféu e Menu: `10 px`;
- posição vertical: `10 px`;
- `expand_icon = true`;
- `clip_contents = true`;
- botões sem moldura visível (`flat`).

## HUD de escolhas A/B/C/D

O painel visual de escolhas permanece com a disposição:

`A | B`

`C | D`

A escala `0.28` ainda ficou pequena no teste. Aplicando o critério de dobrar o aumento anterior, a nova escala passa a ser:

`0.52`

O painel continua centralizado horizontalmente e preso à região inferior da tela.

## Regra futura aprovada — Troféus

Assim que o tamanho e a apresentação do ícone de Troféu forem aprovados na HUD principal, **o mesmo ícone deve ser reutilizado como padrão visual na interface/lista de troféus e conquistas conquistadas**.

Não criar uma segunda identidade visual de troféu para a tela de conquistas; reutilizar o asset aprovado em:

`godot/assets/ui/icons/trophy.png`

## Implementação

Os ajustes deste piloto ficam centralizados em:

`godot/scripts/ui_fine_tune.gd`

Isso permite calibrar rapidamente posição e escala sem alterar a lógica principal já validada da Recepção.
