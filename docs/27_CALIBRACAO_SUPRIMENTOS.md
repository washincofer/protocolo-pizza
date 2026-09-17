# Calibração — Suprimentos

Status: implementado, aguardando validação visual em execução.

## Hotspots calibrados

Formato autoritativo: `(X1, Y1, X2, Y2)`.

- Almoxarifado: `(1217,683,1540,180)`
- Stan Leilo / Aprovação de Compras: `(395,719,820,403)`
- Três Cotações: `(320,415,490,320)`
- Sala de Compras: `(38,715,132,87)`
- Saída — Comunicação / Hall: `(630,915,1100,845)`

## Navegação

A sala anterior é Comunicação.

A saída de Suprimentos oferece:
- Voltar para Comunicação — sempre disponível.
- Avançar para o Hall Corporativo — disponível somente após `boss_supplies_done`.

Derrotar Stan Leilo não muda mais de cenário automaticamente no fluxo refinado de Suprimentos. O jogador permanece livre para explorar a sala e usa a Saída quando desejar avançar.

## Chefe — Stan Leilo

Requisitos preservados:
- Carimbo de Prioridade Executiva selecionado.
- Conhecimento `CC-0001`.

Ao cumprir os requisitos:
- define `boss_supplies_done`;
- libera a conquista `Compra emergencial`;
- mantém o jogador em Suprimentos;
- informa que o acesso ao Hall está liberado.

## Hotspots de risco / finais

Os três hotspots que antes encerravam a partida imediatamente agora abrem escolhas antes de qualquer final:

### Três Cotações
- Escolher o menor preço mantém o final `MENOR PREÇO` e a conquista `Economia de R$ 2`.
- Comparar escopo/prazo/qualidade evita o final.
- Fechar a planilha evita o final.

### Almoxarifado
- Entregar a pizza para conferência mantém o final `MATERIAL RETIDO`.
- Informar que é perecível e tem destinatário evita o final.
- Exigir termo de responsabilidade evita o final.

### Sala de Compras
- Entregar uma fatia para homologação mantém o final `FORNECEDOR HOMOLOGADO`.
- Explicar que o fornecedor é a pizzaria evita o final.
- Pedir o formulário de homologação evita o final.

Esse passa a ser o padrão recomendado para hotspots de final: o jogador recebe uma decisão clara antes da consequência irreversível.

## Balões

Todos os diálogos e feedbacks específicos de Suprimentos usam âncoras próximas aos respectivos hotspots. O sistema global de flip de balões continua responsável por inverter o balão quando a âncora estiver próxima das bordas da tela.

## Implementação

- `godot/scripts/hotspot_catalog.gd`: coordenadas calibradas + saída.
- `godot/scripts/supplies_flow.gd`: fluxo isolado de Suprimentos, escolhas, chefe e navegação.
- `godot/project.godot`: autoload `SuppliesFlow`.
