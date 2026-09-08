# Itens e estados

## Estado da pizza

A pizza acompanha cinco dimensões globais:

- temperatura;
- integridade;
- quantidade;
- tempo decorrido;
- posse.

Representação sugerida:

```text
pizza.temperature = 100.0
pizza.integrity = 100.0
pizza.quantity = 100.0
pizza.elapsed_time = 0.0
pizza.possessed = true
```

Faixas sugeridas como constantes ajustáveis:

```text
HOT_THRESHOLD = 70
COLD_THRESHOLD = 40
MAX_DELIVERY_TIME = valor de balanceamento
```

O micro-ondas do RH, quando desbloqueado, restaura apenas a temperatura para 100%. Não restaura integridade nem quantidade.

## Recursos confirmados

| Recurso | Origem | Uso principal |
|---|---|---|
| Crachá de Visitante | Recepção | acesso inicial |
| Óculos VR | Inovação | TI |
| Carimbo de Prioridade Executiva | Comunicação | Suprimentos |
| CC-0001 | Comunicação | Suprimentos |
| Comprovante de Prestador Terceirizado | Financeiro | RH |
| Protocolo de Exceção Fiscal | Financeiro | Jurídico |
| Colete de Manutenção | Engenharia | Vigilância |
| Ordem de Serviço | Engenharia | Vigilância |
| Assinatura de Validação do RH | RH | Jurídico |
| Bolota do Jurídico — Pendente | Documentação | Jurídico |
| Bolota do Jurídico — Aprovada | Jurídico | conclusão do processo jurídico |

## Bolota

Estado inicial após Documentação:

`BOLOTA_DO_JURIDICO = pendente`

Após vencer Jurídico:

`BOLOTA_DO_JURIDICO = aprovada`

Importante: a Bolota aprovada conclui o processo jurídico, mas **NÃO é exigida pela Diretoria**. O acesso final depende apenas do conhecimento correto do nome do Diretor.

## Conhecimentos

Informações podem ser recursos sem ocupar inventário.

Canônicos:

```text
CC_0001 = Centro de custo da Diretoria
DIRETOR = Ronaldo Gilberto
```

Estados sugeridos:

```text
cc_0001_known = false
director_name_known = false
```

## Disfarces

Vigilância introduz estado equipável:

`DISFARCE = manutencao`

O estado é obtido ao usar o Colete de Manutenção no protagonista.

## Estados principais da campanha

```text
reception_initial_dialogue_done
auditorium_speaker_route
innovation_low_collaboration
ti_cleared
communication_cleared
supplies_cleared
finance_resources_complete
engineering_resources_complete
maintenance_disguise_equipped
surveillance_cleared
rh_point_digital
rh_point_parallel
rh_validation_1
rh_validation_2
rh_microwave_unlocked
rh_cleared
documentation_cleared
legal_ticket_open
legal_external_authorization
legal_cleared
director_access_granted
```

## Persistência

Persistentes entre partidas:

- conquistas desbloqueadas;
- finais vistos.

Inventário, estados de processo e condição da pizza pertencem à campanha atual.
