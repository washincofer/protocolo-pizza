# PROTOCOLO: PIZZA — Ajustes finos da UI piloto da Recepção

Data de calibração: 2026-09-10

## Balões de fala

A Recepção permanece como área piloto da nova UI de diálogo.

Após a primeira rodada de teste, os balões foram deslocados mais 20 px para a direita. O deslocamento total adotado no piloto passa a ser:

`+72 px em X` e `-58 px em Y`

Esse mesmo deslocamento deve ser aplicado aos demais balões da Recepção durante esta rodada de calibração.

Também foi ativado o alinhamento central do conteúdo textual dos balões:

- alinhamento horizontal central;
- alinhamento vertical central;
- área de texto expandida dentro do espaço útil do balão.

## Ícones de Troféu e Menu

Os ícones da HUD no canto superior direito ainda estavam visualmente grandes e parcialmente fora da área útil em teste.

Nesta rodada, o desenho do ícone passa a ser renderizado como um `TextureRect` controlado dentro de um botão invisível maior, garantindo tamanho visual e área de clique independentes.

Parâmetros atuais:

- tamanho visual: `10 × 10 px`;
- área clicável: `28 × 28 px`;
- margem direita: `18 px`;
- espaço entre Troféu e Menu: `8 px`;
- posição vertical: `16 px`;
- botões sem moldura visível (`flat`).

## HUD de escolhas A/B/C/D

O painel visual de escolhas permanece com a disposição:

`A | B`

`C | D`

Após o teste inicial, a escala foi aumentada em 30% em relação ao valor `0.20`.

Escala atual:

`0.26`

A implementação continua sendo piloto. Depois do teste visual, o valor pode ser refinado sem alterar a lógica dos diálogos.

## Regra futura aprovada — Troféus

Assim que o tamanho e a apresentação do ícone de Troféu forem aprovados na HUD principal, **o mesmo ícone deve ser reutilizado como padrão visual na interface/lista de troféus e conquistas conquistadas**.

Não criar uma segunda identidade visual de troféu para a tela de conquistas; reutilizar o asset aprovado em:

`godot/assets/ui/icons/trophy.png`

## Implementação

Os ajustes deste piloto ficam centralizados em:

`godot/scripts/ui_fine_tune.gd`

Isso permite calibrar rapidamente posição e escala sem alterar a lógica principal já validada da Recepção.
