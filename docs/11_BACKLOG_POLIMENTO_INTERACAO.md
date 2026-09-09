# PROTOCOLO: PIZZA — Backlog de Polimento de Interação

Status: **P01/P02 CORRIGIDOS — AGUARDANDO TESTE NO RENDER**

Contexto: durante os testes do protagonista e das interações foram identificados conflitos entre gameplay, diálogo e overlays. A correção foi implementada após a revisão dos cenários principais.

## P01 — Diálogo continuava clicável com menu de pausa aberto

### Situação observada
- O jogador iniciava um diálogo por hotspot/NPC.
- Pressionava `Esc`.
- O menu de pausa aparecia.
- O diálogo anterior continuava clicável simultaneamente.

### Correção aplicada
- A camada da pausa foi elevada acima da camada de diálogo.
- Um guard central de interação detecta overlays ativos.
- Enquanto pausa, inventário, conquistas ou modal estiverem ativos, a camada de diálogo fica bloqueada/oculta.
- Ao retornar ao gameplay, o diálogo pode voltar ao estado anterior quando ainda estiver ativo.

Status: **CORRIGIDO / TESTE PENDENTE**

---

## P02 — Protagonista continuava se movendo com menu de pausa aberto

### Situação observada
- O jogador pressionava `Esc` durante o gameplay.
- O menu de pausa era exibido.
- Cliques no cenário ainda podiam iniciar ou continuar deslocamento.

### Correção aplicada
- Foi criado `InteractionGuard` como guard central de input/modal.
- Enquanto houver pausa, inventário, conquistas, Save/Load, Opções ou diálogo ativo:
  - clique livre no cenário fica bloqueado;
  - input de movimento do protagonista fica suspenso;
  - deslocamento em andamento fica congelado durante overlays de interface;
  - ao fechar o overlay, o controle retorna.

Status: **CORRIGIDO / TESTE PENDENTE**

---

## Correções relacionadas feitas na mesma rodada

- retorno ao Menu Principal encerra corretamente a run ativa;
- hotspots residuais de subáreas não devem ser recriados sobre o menu;
- hotspots do Menu Principal são recalibrados ao retornar ao menu;
- Colete de Manutenção voltou a poder ser vestido pelo Inventário;
- as 13 áreas principais foram padronizadas para a geometria 1672×941.

## Próxima validação

Testar no Render:
1. abrir diálogo e pressionar `Esc`;
2. clicar no cenário enquanto a pausa estiver aberta;
3. sair da TI para o Menu Principal e verificar ausência do hotspot de Servidores;
4. conferir alinhamento de Novo Jogo / Save-Load / Opções ao retornar ao menu;
5. vestir o Colete, selecionar a OS e atravessar a Vigilância.
