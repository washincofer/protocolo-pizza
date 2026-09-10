# PROTOCOLO: PIZZA — UI de Menus Funcional

Data: 2026-09-10

## Estado

Primeira implementação funcional das novas telas de interface baseada nos assets aprovados e comitados em `godot/assets/ui/`.

O arquivo `godot/assets/ui/menus/menu_panels.png` é usado como atlas visual. Cada tela recorta apenas o painel correspondente em tempo de execução, evitando duplicação de imagens.

## Telas implementadas

### ESC / Pausa
- Continuar
- Inventário
- Troféus
- Save / Load
- Opções
- Voltar ao Menu
- Sair do jogo

O `ESC` abre e fecha a nova interface durante a partida.

### Inventário
- abas Todos / Documentos / Itens / Equipamentos
- grade de 15 slots visíveis
- ícones dos itens existentes
- nome e descrição
- ação Selecionar
- ação Vestir para o Colete de Manutenção
- X retorna ao menu de Pausa quando aberto a partir dele

### Troféus
- contador dinâmico com base nas 22 conquistas oficiais
- barra de progresso
- lista rolável
- troféu aprovado na HUD reutilizado para conquistas desbloqueadas
- conquistas bloqueadas permanecem visíveis pelo nome

### Save / Load
- abas Salvar / Carregar
- quatro slots visuais
- metadados de área, tempo e data
- salvar
- carregar
- apagar slot
- quando aberto pelo menu principal, Salvar fica indisponível sem partida ativa e Carregar continua funcional

### Opções
Abas:
- Geral
- Áudio
- Controles
- Vídeo
- Acessibilidade

Funcional nesta etapa:
- Volume geral
- Música
- Efeitos sonoros
- Tela cheia
- Restaurar padrões
- Aplicar

Controles, Vídeo e Acessibilidade exibem as informações atuais e ficam preparados para ampliação posterior.

## Integração

Novo autoload:

`MenuUI="*res://scripts/menu_ui_manager.gd"`

O sistema cria proxies transparentes sobre:
- ícone de Menu da HUD
- ícone de Troféu da HUD
- Save / Load do menu principal
- Opções do menu principal

Isso permite usar a UI nova sem remover de imediato a lógica antiga, reduzindo risco de regressão durante o piloto.

`InteractionGuard` reconhece `MenuUI.overlay_layer` para impedir movimento/interação com o cenário atrás das telas.

## Padrão de identidade

Todas as telas pertencem a **PROTOCOLO: PIZZA**.

A identidade PAPO SAPÃO permanece no universo visual, mas o produto/jogo é identificado como `PROTOCOLO: PIZZA`.

## Próxima etapa

Testar no Render e calibrar visualmente, tela por tela:
1. ESC / Pausa
2. Inventário
3. Troféus
4. Save / Load
5. Opções

A calibração deve seguir o mesmo método usado na Recepção: screenshot + coordenadas quando necessário.
