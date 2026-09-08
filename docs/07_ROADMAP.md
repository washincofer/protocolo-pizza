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

## Fase 4 — densidade, cenários e polimento

**EM ANDAMENTO**

- [x] inventário dos cenários principais;
- [x] tela inicial ilustrada com Novo Jogo / Save-Load / Opções;
- [x] cenários principais incorporados à build Godot distribuída em ZIP;
- [ ] corrigir branding antigo “Pizza Sempre Chega S.A.” nas artes para **PAPO SAPÃO**;
- [ ] revisar hotspots inúteis e easter eggs;
- [ ] revisar diálogos repetidos;
- [ ] revisar ritmo entre chefes;
- [ ] balancear temperatura e tempo máximo;
- [ ] revisar áudio, vinhetas e efeitos;
- [ ] executar playtest de todos os finais e conquistas.

## Fase 5 — migração/produção em Godot

**EM ANDAMENTO — BUILD 0.2**

### Base técnica

- [x] projeto Godot 4.3+;
- [x] autoload `GameState`;
- [x] `AchievementManager`;
- [x] `EndingManager`;
- [x] `SceneRouter`;
- [x] `SaveManager`;
- [x] menu Novo Jogo / Save-Load / Opções;
- [x] 3 slots de save/load;
- [x] configuração de exportação compatível com Godot 4.3 / Web;
- [x] rota canônica implementada.

### Correção 0.2 — point-and-click real

- [x] menu usa a própria arte aprovada, sem painel visual divergente;
- [x] hotspots transparentes sobre Novo Jogo / Save-Load / Opções;
- [x] cenas usam hotspots posicionados sobre NPCs, portas, objetos e subáreas;
- [x] hover visual para indicar elementos clicáveis;
- [x] inventário selecionável;
- [x] mecânica **item → alvo** para Óculos VR, Carimbo, OS e Bolota;
- [x] Colete equipável no protagonista;
- [x] Hall com Financeiro / Engenharia por clique no cenário;
- [x] RH dividido em validações clicáveis;
- [x] Jurídico dividido em chamado, autorização e mesa de análise;
- [x] escolha do nome do diretor antes do Gabinete;
- [x] finais alternativos principais ligados a hotspots de risco.

### Próximas passagens

1. [ ] caminhada animada do protagonista entre hotspots;
2. [ ] separar subáreas em cenas próprias quando necessário;
3. [ ] migrar todos os diálogos completos do protótipo HTML;
4. [ ] implementar todos os finais alternativos restantes;
5. [ ] implementar catálogo/galeria de conquistas dentro do Godot;
6. [ ] arte final com branding **PAPO SAPÃO** em todos os cenários;
7. [ ] áudio e animações;
8. [ ] regressão de toda a árvore de finais;
9. [ ] build de distribuição.

## Regra de escopo

Nenhum novo departamento, final ou conquista será adicionado antes do primeiro playtest integral, salvo correção de inconsistência que impeça a campanha de funcionar.

Após jogar a versão completa, o catálogo pode ser reavaliado com base em experiência real de jogo.
