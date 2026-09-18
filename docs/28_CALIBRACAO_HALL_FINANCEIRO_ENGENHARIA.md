# Calibração — Hall, Financeiro e Engenharia

## Status

Calibração recebida e aplicada como referência canônica em 18/09/2026.

Os quatro valores informados pelo F3 seguem o padrão:

`[X1, Y1, X2, Y2]`

O `DebugTools` usa `bounds` como fonte autoritativa.

## Hall Corporativo

- Engenharia: `[1406,624,1601,248]`
- Financeiro: `[102,623,305,283]`
- Escadas: `[714,272,959,178]`
- Banco de Espera: `[329,600,619,478]`
- Painel de Diretórios: `[660,517,1026,282]`

Observação: o ponto informado como “Diretoria” corresponde visualmente ao Painel de Diretórios do Hall e mantém a ação `hall_map`.

## Financeiro

- Bruno Basco: `[506,493,723,337]`
- Arquivo / Carlos: `[1424,483,1579,334]`
- Voltar ao Hall: `[0,925,546,765]`
- Calculadora: `[1062,650,1127,583]`
- Pasta de Reembolso: `[1267,334,1370,204]`

## Engenharia

- Bento Tróti: `[616,592,807,384]`
- Colete de Manutenção: `[1225,700,1311,587]`
- Ordem de Serviço: `[0,577,86,475]`
- Análise estrutural da pizza: `[392,513,468,436]`
- Voltar ao Hall: `[1413,684,1570,212]`

## Padrão visual de coleta

A partir desta calibração, itens coletáveis que possuem arte própria devem aparecer fisicamente no hotspot antes da coleta.

Fluxo:

`item visível na cena → clique/interação → GameState.add_item() → item some da cena → item aparece no inventário`

Aplicado aos itens com arte já disponível:

- Crachá de Visitante;
- Óculos VR;
- Carimbo de Prioridade Executiva;
- Comprovante de Prestador Terceirizado;
- Protocolo de Exceção Fiscal;
- Colete de Manutenção;
- Ordem de Serviço;
- Bolota do Jurídico.

Para NPCs que entregam documentos, o item visual desaparece após a entrega, mas o hotspot do NPC continua ativo.

Para itens físicos coletados diretamente, o hotspot é desativado depois da coleta, evitando coleta duplicada.
