# Roadmap

## Fase 1 — espinha dorsal narrativa

**CONCLUÍDA**

- [x] Recepção
- [x] Inovação
- [x] TI
- [x] Comunicação
- [x] Suprimentos
- [x] Hall Corporativo
- [x] Financeiro
- [x] Engenharia
- [x] Vigilância
- [x] RH
- [x] Documentação
- [x] Jurídico
- [x] Diretoria
- [x] Final canônico

## Fase 2 — fechamento de conteúdo-base

**CONCLUÍDA**

- [x] nome oficial da empresa: **PAPO SAPÃO**;
- [x] elenco funcional principal;
- [x] catálogo de finais para a primeira versão completa;
- [x] catálogo fechado de 22 conquistas;
- [x] nenhuma conquista secreta;
- [x] condição de desbloqueio definida para todas as conquistas;
- [x] fluxograma jogável completo;
- [x] estados globais e backtracking definidos.

## Fase 3 — protótipo completo

**MARCO APROVADO — PROTÓTIPO COMPLETO 1.0**

O protótipo HTML integral foi gerado e aprovado em validação inicial pelo projeto.

Implementado no Protótipo Completo 1.0:

1. [x] campanha jogável da Recepção até a Diretoria;
2. [x] estado global de inventário, conhecimentos e flags;
3. [x] temperatura, integridade, quantidade, tempo e posse da pizza;
4. [x] backtracking Hall ↔ Financeiro ↔ Engenharia;
5. [x] bloqueios de progressão em Vigilância, RH e Jurídico;
6. [x] finais alternativos principais do catálogo;
7. [x] 22 conquistas com persistência local no navegador;
8. [x] galeria/lista de finais vistos com persistência local;
9. [ ] save/load completo da campanha em andamento no HTML;
10. [ ] playtest exaustivo de todas as rotas, finais e combinações de estados.

### Decisão de marco

O **Protótipo Completo 1.0 está APROVADO** como base funcional da campanha.

## Fase 4 — densidade e polimento

**EM ANDAMENTO EM PARALELO COM A MIGRAÇÃO GODOT**

### Cenários

- [x] tela inicial / menu conceitual;
- [x] Recepção;
- [x] Inovação;
- [x] TI;
- [x] Comunicação;
- [x] Suprimentos;
- [x] Hall Corporativo;
- [x] Financeiro;
- [x] Engenharia;
- [x] Vigilância;
- [x] RH;
- [x] Documentação;
- [x] Jurídico;
- [x] Diretoria;
- [ ] corrigir branding provisório de cenários antigos para **PAPO SAPÃO**;
- [ ] separar hotspots e subáreas finais sobre os cenários;
- [ ] lock de arte após playtest visual.

### Polimento restante

- [ ] revisar hotspots inúteis e easter eggs;
- [ ] revisar diálogos repetidos;
- [ ] adicionar respostas contextuais para itens em locais errados;
- [ ] revisar ritmo entre chefes;
- [ ] ajustar tempo de espera da Recepção;
- [ ] balancear queda de temperatura;
- [ ] balancear `MAX_DELIVERY_TIME`;
- [ ] revisar pistas para evitar travamentos de compreensão;
- [ ] revisar humor para público família;
- [ ] revisar áudio, vinhetas e efeitos;
- [ ] revisar feedback visual de itens, conhecimentos e processos contornados;
- [ ] executar playtest de todos os finais e conquistas.

## Fase 5 — migração/produção em Godot

**EM ANDAMENTO — PRODUCTION BASE 0.1**

1. [x] evoluir o projeto Godot inicial para base funcional;
2. [x] implementar autoload `GameState`;
3. [x] implementar `AchievementManager`;
4. [x] implementar `EndingManager`;
5. [x] implementar `SceneRouter`;
6. [x] implementar `SaveManager` com 3 slots;
7. [x] implementar `SettingsManager` e tela de Opções;
8. [x] implementar `GameFlow` da rota canônica;
9. [x] implementar menu com Novo Jogo, Save/Load e Opções;
10. [x] mapear os cenários como backgrounds da build local;
11. [ ] migrar subáreas e hotspots reais;
12. [ ] migrar diálogos completos e escolhas do HTML aprovado;
13. [ ] implementar todos os finais alternativos no Godot;
14. [ ] ligar as 22 conquistas às condições completas no Godot;
15. [ ] implementar inventário visual e uso item → alvo;
16. [ ] implementar caminhada point-and-click do protagonista;
17. [ ] corrigir branding visual e importar assets finais;
18. [ ] implementar animações e áudio finais;
19. [ ] executar testes de regressão de toda a árvore de finais e saves;
20. [ ] preparar build de distribuição.

## Regra de escopo

Nenhum novo departamento, final ou conquista será adicionado antes do primeiro playtest integral, salvo correção de inconsistência que impeça a campanha de funcionar.

Após jogar a versão completa, o catálogo pode ser reavaliado com base em experiência real de jogo.
