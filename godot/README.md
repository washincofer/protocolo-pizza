# PROTOCOLO: PIZZA — Godot 0.2

Esta versão corrige os dois pontos identificados no teste da 0.1:

1. **Menu fiel à arte aprovada** — a imagem do menu é a própria interface. Os botões visuais `Novo Jogo`, `Save/Load` e `Opções` possuem hotspots transparentes exatamente por cima.
2. **Cenários realmente jogáveis** — a navegação deixou de ser uma lista de botões. As artes são cenas point-and-click com regiões clicáveis, hover, inventário selecionável, uso `item → alvo`, diálogo e transições.

## Como abrir
Abra `project.godot` no Godot 4.x e execute o projeto.

## Controles
- Clique nos objetos/NPCs destacados quando o mouse passa sobre eles.
- Clique em um item no inventário e depois no alvo do cenário.
- Para vestir o `Colete`, clique nele uma segunda vez no inventário.
- Menu ☰ no canto superior direito abre Save/Load e Opções.

## Fluxo implementado
Recepção → Inovação → TI → Comunicação → Suprimentos → Hall → Financeiro/Engenharia → Vigilância → RH → Documentação → Jurídico → Diretoria.

## Observação de arte
Alguns cenários antigos ainda exibem a marca visual anterior `Pizza Sempre Chega S.A.` dentro da própria ilustração. A lógica usa **PAPO SAPÃO**; a substituição visual desses textos continua no lock final de arte.
