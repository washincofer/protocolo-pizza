# PROTOCOLO: PIZZA — Ajustes finos da UI piloto da Recepção

Data de calibração: 2026-09-10

## Balões de fala

A Recepção permanece como área piloto da nova UI de diálogo.

O deslocamento total adotado permanece em:

`+292 px em X` e `-58 px em Y`

A orientação original da arte permanece ativa, sem `flip_h`.

O conteúdo textual dos balões foi aprovado e deve permanecer sem novas alterações nesta etapa:

- alinhamento horizontal central;
- alinhamento vertical central;
- `VBoxContainer` centralizado;
- área de texto expandida dentro do espaço útil do balão;
- bloco de texto deslocado `+6 px` em Y para baixo.

## Ícones de Troféu e Menu

A apresentação atual foi aprovada visualmente na Recepção.

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

O painel permanece com escala visual `0.52`, centralizado horizontalmente e deslocado `118 px` para cima a partir da base.

As áreas úteis de texto foram calibradas diretamente em coordenadas de tela de referência `1280 × 720`:

- A: `(487,514)` até `(702,551)`;
- B: `(789,514)` até `(1005,551)`;
- C: `(487,579)` até `(702,602)`;
- D: `(789,580)` até `(1005,619)`.

As áreas clicáveis foram calibradas separadamente, também na referência `1280 × 720`:

- A: `(430,506)` até `(720,560)`;
- B: `(732,506)` até `(1020,560)`;
- C: `(430,570)` até `(720,625)`;
- D: `(732,570)` até `(1020,625)`.

O código converte tanto as áreas de texto quanto os hotspots clicáveis proporcionalmente quando a viewport muda, preservando a composição.

Os textos são centralizados horizontal e verticalmente dentro de cada campo e o tamanho da fonte é reduzido automaticamente para opções longas.

## Inventário inferior

O painel de inventário inferior da HUD foi ocultado na Recepção por ser redundante com o inventário disponível no menu `Esc`.

A decisão de design para a próxima etapa é avaliar uma **hotbar horizontal de slots** no rodapé, inspirada em jogos MMORPG, para acesso rápido aos principais itens coletáveis. O inventário completo continuará disponível pelo menu.

## Regra futura aprovada — Troféus

O ícone de Troféu aprovado na HUD principal deve ser reutilizado como padrão visual na interface/lista de troféus e conquistas conquistadas.

Não criar uma segunda identidade visual de troféu para a tela de conquistas; reutilizar o asset aprovado em:

`godot/assets/ui/icons/trophy.png`

## Implementação

Os ajustes deste piloto ficam centralizados em:

`godot/scripts/ui_fine_tune.gd`

Isso permite calibrar rapidamente posição e escala sem alterar a lógica principal já validada da Recepção.
