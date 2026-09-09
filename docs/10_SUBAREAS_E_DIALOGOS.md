# PROTOCOLO: PIZZA — Subáreas e Diálogos Interativos

## Estado
Implementação inicial ativa para playtest Web/Godot.

## Sistema de diálogo
`DialogueUI` é a camada reutilizável de perguntas/respostas.

Formato visual atual:
- nome do NPC;
- fala/pergunta;
- opções A / B / C / D;
- cada escolha pode alterar flags, inventário, conhecimento, rota, conquista ou final.

### Recepcionista — Eliana Marli
Pergunta inicial: `Boa tarde. Posso ajudar?`

- A — Sou entregador. Vim entregar a pizza para o diretor.
  - identifica o entregador;
  - adiciona o crachá;
  - ensina `Ronaldo Gilberto`;
  - mantém rota canônica.
- B — Quero entrar na empresa.
  - leva ao Auditório / Onboarding.
- C — Tenho uma entrega, mas não sei para quem.
  - final `DESTINO NÃO ENCONTRADO`.
- D — Estou esperando alguém.
  - leva à Sala de Espera.

### Auditório — Lúcia Pauta
- A — assumir a identidade do palestrante;
- B — falsificar cadastro;
- C — realizar a apresentação e gastar tempo de entrega;
- D — admitir que é o entregador e voltar à Recepção.

O componente será reutilizado nos próximos NPCs com decisões relevantes.

## Subáreas ligadas para teste

### Recepção
- `reception_waiting_room` — Sala de Espera
- `reception_auditorium` — Auditório / Onboarding

### Inovação
- `innovation_meeting_room` — Sala de Reunião

### TI
- `ti_server_room` — Sala de Servidores
- `ti_service_desk` — Service Desk

### RH
- `rh_time_control` — Controle de Ponto
- `rh_third_party_registration` — Cadastro de Terceiros

### Documentação
- `documentation_archive_reprography` — Arquivo / Reprografia

## Calibração
Os hotspots das novas subáreas são provisórios nesta primeira integração.

Use `F2` para exibir as áreas clicáveis e `F3` para obter as coordenadas `Imagem X/Y`. As correções devem usar as coordenadas da imagem, pois permanecem válidas independentemente do tamanho da janela.

## Próxima rodada
1. playtest da Recepção 2.0;
2. calibrar os hotspots das duas subáreas da Recepção;
3. validar diálogos e consequências;
4. calibrar Inovação / TI / RH / Documentação;
5. expandir o sistema A-D para os demais NPCs relevantes.
