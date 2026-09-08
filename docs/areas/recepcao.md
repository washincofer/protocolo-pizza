# Área 1 — Recepção / Térreo

## Função da área
A Recepção é a abertura do jogo e funciona como tutorial orgânico de identificação, acesso, escolhas, exploração e consequências.

Subáreas canônicas nesta fase:
- Sala de Espera
- Auditório

A quantidade total de subáreas do projeto continuará variável por setor; esta definição vale apenas para a revisão atual da Área 1.

## NPCs

- **Eliana Marli** — recepcionista principal.
- **Mauro Portela** — segurança do térreo.
- **Lúcia Pauta** — facilitadora do onboarding no Auditório.

---

## Sala de Espera

### Função
Não é apenas cenário. É uma área de risco baseada em tempo e diálogo.

### Regra principal
Se o jogador permanecer na Sala de Espera por mais de **15 segundos**, Mauro Portela aparece e inicia uma conversa.

O resultado depende da escolha do jogador:
- respostas adequadas permitem que ele permaneça ou volte ao fluxo normal;
- respostas suspeitas, agressivas, absurdas ou contraditórias podem levar à retirada do prédio;
- uma das rotas deve permitir o final alternativo em que o entregador é expulso antes de concluir a entrega.

### NPCs de espera
A sala pode conter outras pessoas aguardando atendimento, cada uma com um assunto corporativo absurdo ou cotidiano engraçado. Esses NPCs servem para:
- piadas ambientais;
- pistas opcionais;
- worldbuilding da PAPO SAPÃO;
- pequenas escolhas de diálogo;
- possíveis conquistas por interação.

Exemplos de situações:
- funcionário aguardando autorização para algo que já foi autorizado;
- candidato de onboarding que não sabe em qual empresa foi contratado;
- fornecedor aguardando há tanto tempo que já conhece todos pelo nome;
- pessoa esperando assinatura de alguém que está sentado ao lado dela;
- visitante com senha de atendimento cujo painel nunca chama aquele número.

### Gatilho do guarda
Condição sugerida de implementação:
`tempo_na_sala_espera >= 15s AND guarda_ainda_nao_interveio`

Ao disparar, inicia-se diálogo obrigatório com Mauro.

Objetivo de design:
ensinar cedo que permanecer parado ou explorar demais também pode alterar o estado do jogo.

---

## Auditório

Subárea opcional/bônus da Recepção.

**Lúcia Pauta** conduz o onboarding e pode confundir o entregador com o palestrante esperado.

O Auditório serve principalmente para:
- exploração;
- humor;
- onboarding acontecendo no mesmo dia;
- pistas e falas ambientais;
- conquistas e interações opcionais;
- permitir que o jogador informe um nome para o protagonista na partida atual.

---

## Informação canônica do diretor

Ao seguir a rota correta e informar que a pizza é para a Diretoria, Eliana Marli confirma o destinatário:

> — Pizza para a Diretoria? Para o Sr. Ronaldo Gilberto?

O jogo registra:

**INFORMAÇÃO ADQUIRIDA — Diretor: Ronaldo Gilberto**

Estado sugerido:

`nome_diretor_conhecido = true`

Essa informação será exigida somente na Diretoria e funciona como conhecimento aprendido, não como item físico.

---

## Continuidade canônica da Recepção

Fluxo principal:
1. identificar-se com Eliana Marli;
2. pedido é localizado;
3. aprender o nome **Ronaldo Gilberto**;
4. receber crachá de visitante/terceiro;
5. falar com Mauro Portela;
6. segurança verifica o acesso inicial;
7. um elevador está em manutenção;
8. outro está reservado/travado para o presidente;
9. escadas são usadas inicialmente.

O crachá da Recepção comprova apenas acesso físico como visitante. Ele não substitui o **Comprovante de Prestador Terceirizado** obtido depois no Financeiro.

Finais ligados ao térreo já aprovados incluem:
- **ENTREGA ABANDONADA**;
- **DESTINO NÃO ENCONTRADO**;
- **VISITANTE RETIRADO**;
- **PIZZA APREENDIDA**;
- **ACESSO NÃO AUTORIZADO**;
- **IDENTIDADE FALSIFICADA**.
