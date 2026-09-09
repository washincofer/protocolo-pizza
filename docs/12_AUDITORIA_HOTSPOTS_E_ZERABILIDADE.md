# PROTOCOLO: PIZZA — Auditoria de Hotspots e Zerabilidade

Status: **ROTA CANÔNICA LOGICAMENTE COMPLETA / CALIBRAÇÃO VISUAL PENDENTE**

## Escopo da auditoria

Foram conferidos:
- catálogo das 13 áreas principais;
- ações correspondentes no `GameFlow`;
- interceptações de subáreas no `SubareaManager`;
- requisitos para atravessar os cinco chefes;
- sequência até a Diretoria e o final canônico.

## Áreas principais e hotspots cadastrados

| Área | Hotspots principais |
|---|---:|
| Recepção | 6 |
| Inovação | 6 |
| TI | 4 + entrada adicional de Servidores |
| Comunicação | 4 |
| Suprimentos | 4 |
| Hall | 5 |
| Financeiro | 5 |
| Engenharia | 5 |
| Vigilância | 4 |
| RH | 5 |
| Documentação | 4 |
| Jurídico | 4 |
| Diretoria | 3 |

Além destes, existem hotspots próprios nas subáreas já implementadas.

## Caminho canônico conferido

Recepção
→ identificação e nome de Ronaldo Gilberto
→ Inovação
→ obter Óculos VR
→ TI
→ usar VR em Rogério Wilco
→ Comunicação
→ obter CC-0001 e Carimbo de Prioridade Executiva
→ Suprimentos
→ aprovar compra emergencial
→ Hall
→ Financeiro e Engenharia em qualquer ordem
→ obter Comprovante, Protocolo Fiscal, Colete e OS
→ vestir Colete e selecionar OS
→ Vigilância
→ RH
→ concluir ficha, ponto digital, paralelo e validação
→ Documentação
→ obter Bolota pendente
→ Jurídico
→ abrir chamado, obter autorização externa e aprovar Bolota
→ Diretoria
→ informar Ronaldo Gilberto
→ abrir gabinete
→ ENTREGA CONCLUÍDA.

## Correção de zerabilidade aplicada

O inventário separado não estava mais executando a ação de vestir o Colete de Manutenção. Isso bloqueava a passagem por Sônia Bondes.

Agora:
- `Colete de Manutenção` possui ação própria de vestir no Inventário;
- depois de vestido, o jogador pode selecionar a `Ordem de Serviço (OS)`;
- Sônia recebe a combinação necessária: `disguise == maintenance` + OS selecionada.

## Geometria dos cenários

As 13 artes principais atuais estão padronizadas em **1672×941** e o catálogo foi atualizado para a mesma geometria.

## Pendência importante: calibração visual

A lógica dos hotspots está ativa, porém as artes principais foram redesenhadas. Portanto, os retângulos existentes devem ser tratados como **provisórios** até nova calibração com:

- `F2` — exibir hotspots;
- `F3` — exibir coordenadas da imagem.

A calibração deve ser realizada área por área, usando canto superior esquerdo e canto inferior direito do elemento visual correspondente.

## Critério para considerar a versão oficialmente zerável

Após o deploy desta rodada, executar um teste manual completo:

`Novo Jogo → Recepção → ... → Diretoria → ENTREGA CONCLUÍDA`

Somente após esse teste no Render a build deve ser marcada como **ZERÁVEL VALIDADA**.
