# PROTOCOLO: PIZZA

> **Sua missão é simples. O processo não.**

**PROTOCOLO: PIZZA** é uma aventura point-and-click de humor corporativo em que um entregador precisa levar uma pizza ao diretor no último andar de uma empresa. O problema é que, para a empresa, entregar uma pizza é um processo.

Cada departamento funciona como um fluxo burocrático. Os grandes bloqueios são tratados como chefes, mas não existe combate tradicional: o jogador supera cada obstáculo usando itens, informações, documentos, permissões e as próprias regras absurdas da organização.

## Estado atual

O projeto está em pré-produção e prototipação.

- Protótipo de validação: HTML.
- Motor planejado para a versão final: Godot.
- Estrutura narrativa: independente de engine.
- Campanha principal: em consolidação.

## Espinha dorsal atual

```text
Recepção / Térreo
        ↓
Inovação
        ↓
TI — Chefe 1
        ↓
Comunicação
        ↓
Suprimentos — Chefe 2
        ↓
Hall Corporativo
   ↙           ↘
Financeiro   Engenharia
   ↘           ↙
    Vigilância — Chefe 3
             ↓
          RH — Chefe 4
             ↓
       Documentação
             ↓
     Jurídico — Chefe 5
             ↓
          Diretoria
```

O Hall Corporativo introduz exploração não linear e backtracking. Financeiro fornece recurso para RH; Engenharia fornece recurso para Vigilância.

## Mecânica central

```text
Explorar → descobrir problema → obter item/informação → aplicar solução correta → processo contornado
```

A dificuldade aumenta progressivamente:

- TI: item → personagem.
- Suprimentos: item → objeto + informação → personagem.
- Vigilância: equipar item → apresentar documento.
- Jurídico: grande puzzle de requisitos acumulados.

## Pizza

A pizza é um estado de jogo, não apenas um objetivo narrativo. São acompanhados:

- temperatura;
- integridade;
- quantidade;
- tempo de entrega;
- posse.

Chegar ao diretor não garante vitória se a pizza estiver fria, incompleta ou perdida.

## A Bolota do Jurídico

Na área de Documentação o jogador coleta a **Bolota do Jurídico**. Ela só ganha validade quando recebe a aprovação/carimbo do Jurídico. A Diretoria só aceita a entrega se a Bolota estiver devidamente carimbada.

## Final canônico

O entregador finalmente entrega a pizza ao diretor. O diretor aceita a entrega e imediatamente faz **um novo pedido de pizza**.

## Documentação

- [`docs/00_CANON.md`](docs/00_CANON.md) — decisões canônicas.
- [`docs/01_ESPINHA_DORSAL.md`](docs/01_ESPINHA_DORSAL.md) — campanha principal.
- [`docs/02_AREAS_E_SUBAREAS.md`](docs/02_AREAS_E_SUBAREAS.md) — mapa das áreas.
- [`docs/03_CHEFES.md`](docs/03_CHEFES.md) — regras dos chefes.
- [`docs/04_ITENS_E_ESTADOS.md`](docs/04_ITENS_E_ESTADOS.md) — inventário e estados.
- [`docs/05_CONQUISTAS.md`](docs/05_CONQUISTAS.md) — conquistas.
- [`docs/06_TOM_FRASES_E_NOMES.md`](docs/06_TOM_FRASES_E_NOMES.md) — humor, frases e NPCs.
- [`docs/07_ROADMAP.md`](docs/07_ROADMAP.md) — próximos passos.

## Título

Nome técnico do repositório: `protocolo-pizza`  
Título público: **PROTOCOLO: PIZZA**
