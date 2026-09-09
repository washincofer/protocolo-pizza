# PROTOCOLO: PIZZA — Backlog de Polimento de Interação

Status: **MAPEADO / NÃO CORRIGIR AGORA**

Contexto: durante os testes do protagonista e das interações da Recepção, foram identificadas pendências que devem ser corrigidas somente depois da revisão visual dos cenários.

## P01 — Diálogo continua clicável com menu de pausa aberto

### Situação observada
- O jogador inicia um diálogo por hotspot/NPC.
- Pressiona `Esc`.
- O menu de pausa aparece.
- O diálogo anterior continua visível/clicável simultaneamente ao menu de pausa.

### Comportamento esperado
Ao abrir a pausa:
- o diálogo deve ser temporariamente bloqueado ou ocultado;
- nenhuma opção A/B/C/D deve aceitar clique enquanto a pausa estiver ativa;
- ao fechar a pausa, o diálogo pode retornar exatamente ao estado anterior.

### Direção técnica sugerida para depois
Criar um estado global de interface/modal, por exemplo `ui_locked` / `pause_active`, e fazer `DialogueUI` suspender `mouse_filter` ou esconder sua camada enquanto a pausa estiver aberta.

---

## P02 — Protagonista continua se movendo com menu de pausa aberto

### Situação observada
- O jogador pressiona `Esc` durante o gameplay.
- O menu de pausa é exibido.
- Cliques no cenário ainda são capturados pelo `PlayerController` e o personagem continua se movimentando.

### Comportamento esperado
Enquanto qualquer modal de pausa estiver aberto:
- cliques no cenário não devem mover o protagonista;
- cliques em hotspots também não devem iniciar deslocamento/interação;
- o estado e a posição do personagem devem permanecer congelados;
- ao fechar a pausa, o controle volta normalmente.

### Direção técnica sugerida para depois
Adicionar uma verificação explícita no `PlayerController` para ignorar input quando houver modal ativo (`UIPolish`, `DialogueUI`, `AchievementsUI`, Save/Load, Opções etc.). Idealmente consolidar em um único estado de bloqueio de input.

---

## Prioridade futura
Resolver **P01 e P02 juntos** numa rodada de arquitetura de interface/modal, depois da revisão dos cenários e antes do polimento final de navegação.

## Observação
Não alterar o comportamento atual agora. Este documento é apenas o registro oficial das pendências encontradas em teste.
