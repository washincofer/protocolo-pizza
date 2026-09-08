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
9. [ ] save/load completo da campanha em andamento;
10. [ ] playtest exaustivo de todas as rotas, finais e combinações de estados.

### Decisão de marco

O **Protótipo Completo 1.0 está APROVADO** como base funcional da campanha.

A aprovação não congela correções técnicas encontradas em testes futuros. Novos departamentos, finais ou conquistas continuam fora de escopo até o playtest integral, salvo necessidade real identificada durante testes.

## Fase 4 — densidade e polimento

**FASE ATUAL RECOMENDADA**

Após a aprovação funcional do protótipo:

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
- [ ] executar playtest de todos os finais e conquistas;
- [ ] decidir, somente após o playtest, se algum final/conquista adicional é realmente necessário.

## Fase 5 — migração/produção em Godot

Quando o fluxo completo estiver validado em playtest suficiente:

1. [ ] criar projeto Godot definitivo;
2. [ ] implementar autoload `GameState`;
3. [ ] implementar `AchievementManager`;
4. [ ] implementar `EndingManager`;
5. [ ] implementar `SceneRouter`;
6. [ ] implementar `SaveManager`;
7. [ ] importar cenas e diálogos validados;
8. [ ] substituir arte temporária por assets finais;
9. [ ] implementar animações e áudio finais;
10. [ ] executar testes de regressão de toda a árvore de finais;
11. [ ] preparar build de distribuição.

## Regra de escopo

Nenhum novo departamento, final ou conquista será adicionado antes do primeiro playtest integral, salvo correção de inconsistência que impeça a campanha de funcionar.

Após jogar a versão completa, o catálogo pode ser reavaliado com base em experiência real de jogo.
