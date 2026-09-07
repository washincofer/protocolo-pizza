# Itens e estados

## Estado da pizza

A pizza acompanha cinco dimensões:

- temperatura;
- integridade;
- quantidade;
- tempo decorrido;
- posse.

## Recursos confirmados

| Recurso | Origem | Uso principal |
|---|---|---|
| Crachá de Visitante | Recepção | acesso inicial |
| Óculos VR | Inovação | TI |
| Carimbo de Prioridade Executiva | Comunicação | Suprimentos |
| CC-0001 | Comunicação | Suprimentos |
| Comprovante de Prestador Terceirizado | Financeiro | RH |
| Colete de Manutenção | Engenharia | Vigilância |
| Ordem de Serviço | Engenharia | Vigilância |
| Bolota do Jurídico | Documentação | Jurídico / Diretoria |

## Bolota

Estado inicial:

`BOLOTA_DO_JURIDICO = sem_aprovacao`

Após vencer Jurídico:

`BOLOTA_DO_JURIDICO = carimbada`

A Diretoria exige o estado `carimbada`.

## Conhecimento

Informações podem ser recursos sem ocupar inventário.

Exemplo canônico:

`CC-0001 = Centro de custo da Diretoria`

## Disfarces

Vigilância introduz estado equipável:

`DISFARCE = manutencao`

O estado é obtido ao usar o Colete de Manutenção no protagonista.
