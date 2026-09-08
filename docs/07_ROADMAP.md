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

**PRÓXIMA FASE**

Objetivo: transformar o fluxo fechado em uma campanha jogável de ponta a ponta.

Ordem recomendada:

1. [ ] consolidar protótipo HTML em uma versão integral da campanha;
2. [ ] implementar `GameState` com inventário, conhecimentos e flags;
3. [ ] implementar temperatura, integridade, quantidade, tempo e posse da pizza;
4. [ ] implementar backtracking Hall ↔ Financeiro ↔ Engenharia;
5. [ ] implementar bloqueios sem softlock em Vigilância, RH e Jurídico;
6. [ ] implementar todos os finais alternativos fechados;
7. [ ] implementar as 22 conquistas e persistência;
8. [ ] implementar galeria/lista de finais vistos;
9. [ ] implementar save/load;
10. [ ] executar playtest integral.

## Fase 4 — densidade e polimento

Após a campanha funcionar de ponta a ponta:

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
- [ ] revisar feedback visual de itens, conhecimentos e processos contornados.

## Fase 5 — migração/produção em Godot

Quando o fluxo completo estiver validado em playtest:

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
