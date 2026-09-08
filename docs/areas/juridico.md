# Jurídico — Chefe 5

## Papel no jogo

Último grande puzzle burocrático antes da Diretoria. O jogador chega ao Jurídico com três requisitos já conquistados durante a aventura e completa os dois últimos ali mesmo.

## Estrutura fechada

1. **Recepção / Secretaria do Jurídico**
2. **Sala de Análise Jurídica**

Sem subáreas extras: o foco é reunir, validar e encerrar o processo.

## Os cinco requisitos canônicos

1. **Chamado**
2. **Bolota do Jurídico**
3. **Assinatura**
4. **Protocolo**
5. **Autorização externa à empresa**

Origens:

- **Protocolo** → Financeiro, por meio do Protocolo de Exceção Fiscal.
- **Assinatura** → RH, por meio da Assinatura de Validação do RH.
- **Bolota do Jurídico** → Documentação, ainda com status PENDENTE DE APROVAÇÃO.
- **Chamado** → aberto pelo próprio jogador no telefone da mesa da secretária do Jurídico.
- **Autorização externa à empresa** → recebida por telefone alguns segundos depois da abertura do chamado.

## Secretaria — telefone e Chamado

Há um telefone sobre a mesa da secretária. O jogador pode interagir com ele.

Ao ligar para a TI, abre um chamado referente à liberação da entrega para a Diretoria.

A TI fornece um número de chamado.

Estado sugerido:

`chamado_aberto = true`

Exemplo de feedback:

**CHAMADO ABERTO — Nº 48271**

Piada possível:

— Qual a prioridade?

— É a pizza do diretor.

— P1.

O número pode variar por partida ou ser fixo; o importante é que o jogo registre o requisito como obtido.

## Autorização externa

Depois de aproximadamente 5 segundos ou mais a partir da abertura do chamado, o telefone da secretaria toca.

O jogador precisa atender.

Uma voz externa confirma a liberação da entrega e gera o requisito:

**AUTORIZAÇÃO EXTERNA À EMPRESA — RECEBIDA**

Estado sugerido:

`autorizacao_externa = true`

Se o jogador ignorar a ligação, o telefone pode voltar a tocar depois. Não deve haver bloqueio permanente por perder a primeira chamada.

Piada possível:

— A autorização externa foi concedida.

— Por quem?

— Externamente.

— Externamente onde?

— Fora da empresa.

## Sala de Análise Jurídica — Chefe 5

O responsável do Jurídico recebe o jogador apenas quando ele decide iniciar a análise.

A mesa pode ter cinco espaços físicos ou indicadores visuais, um para cada requisito. Isso permite ao jogador enxergar claramente o que possui e o que ainda falta.

Checklist:

- Chamado ✅/❌
- Bolota ✅/❌
- Assinatura ✅/❌
- Protocolo ✅/❌
- Autorização externa ✅/❌

Se faltar algo, o Jurídico não encerra o processo e dá uma pista curta relacionada ao requisito ausente, sem explicar completamente onde obtê-lo.

## Conclusão correta

Quando os cinco requisitos estão presentes:

1. Jurídico confere todos os documentos.
2. Faz uma pausa exageradamente longa para analisar a Bolota.
3. Carimba a Bolota.
4. O item muda de estado.

`Bolota do Jurídico — Pendente de Aprovação → Bolota do Jurídico — Aprovada`

Feedback:

**PROCESSO JURÍDICO CONCLUÍDO**

**PROCESSO CONTORNADO**

A Bolota aprovada representa a conclusão do processo jurídico, mas NÃO é exigida pela secretária da Diretoria. A Diretoria mantém sua regra canônica própria: para entrar, basta saber o nome correto do diretor.

## Humor de análise

Interações sugeridas:

- Um contrato com uma única página útil e dezenas de páginas de anexos.
- Carimbo escrito **CONFERE COM O ORIGINAL**, aplicado sobre uma cópia.
- Pilha de documentos com etiqueta **URGENTE — AGUARDAR**.
- Um livro enorme chamado **POLÍTICA DE SIMPLIFICAÇÃO DE PROCESSOS — VOLUME 8**.
- Funcionário dizendo: “Não posso dar uma orientação jurídica.” e imediatamente dando uma orientação jurídica.

## Finais absurdos

### LI E ACEITO

Se o jogador insistir em aceitar um termo sem ler, o Jurídico entrega um documento enorme e pergunta se ele concorda com tudo. Ao confirmar repetidamente, descobre que aceitou assumir a responsabilidade formal pela pizza durante 30 dias.

Final:

**LI E ACEITO**

> “Você não leu. Mas aceitou com muita convicção.”

### EM ANÁLISE

Se o jogador tentar forçar a aprovação da Bolota sem os cinco requisitos e insistir repetidamente, o processo pode ser enviado para análise por prazo indeterminado.

Final:

**EM ANÁLISE**

> “Seu processo foi encaminhado para o lugar onde processos aguardam outros processos.”

## Regra narrativa

O Jurídico encerra a escalada burocrática. O jogador precisa demonstrar que percorreu o prédio, guardou documentos, compreendeu estados anteriores e executou a última dependência externa.

Depois disso, a Diretoria quebra toda a lógica acumulada: a secretária pergunta apenas o nome do diretor.

## Tom

Humor familiar, cartunesco e acessível para crianças, com leitura corporativa adicional para adultos.
