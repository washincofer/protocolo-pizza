# PROTOCOLO: PIZZA — Ajustes finos da UI piloto da Recepção

Data de calibração: 2026-09-10

## Balões de fala

A Recepção permanece como área piloto da nova UI de diálogo.

Após a nova rodada de teste, todos os balões foram deslocados mais 120 px para a direita no sistema de coordenadas da imagem.

O deslocamento total adotado no piloto passa a ser:

`+292 px em X` e `-58 px em Y`

A orientação original da arte permanece ativa, sem `flip_h`.

O conteúdo textual dos balões foi aprovado e deve permanecer sem novas alterações nesta etapa:

- alinhamento horizontal central;
- alinhamento vertical central;
- `VBoxContainer` centralizado;
- área de texto expandida dentro do espaço útil do balão;
- bloco de texto deslocado `+6 px` em Y para baixo.

## Ícones de Troféu e Menu

A posição dos ícones permanece dentro da tela e a margem direita aprovada foi mantida. Nesta rodada, o tamanho visual aumentou de 15 px para 25 px.

Parâmetros atuais:

- largura visual máxima: `25 px`;
- área clicável: `42 × 42 px`;
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

A escala visual permanece em:

`0.52`

Nesta rodada, o painel foi deslocado 100 px para cima em relação à posição anterior. O deslocamento inferior usado para posicionamento passa de `18 px` para `118 px`.

O painel continua centralizado horizontalmente.

## Regra futura aprovada — Troféus

Assim que o tamanho e a apresentação do ícone de Troféu forem aprovados na HUD principal, **o mesmo ícone deve ser reutilizado como padrão visual na interface/lista de troféus e conquistas conquistadas**.

Não criar uma segunda identidade visual de troféu para a tela de conquistas; reutilizar o asset aprovado em:

`godot/assets/ui/icons/trophy.png`

## Implementação

Os ajustes deste piloto ficam centralizados em:

`godot/scripts/ui_fine_tune.gd`

Isso permite calibrar rapidamente posição e escala sem alterar a lógica principal já validada da Recepção.
