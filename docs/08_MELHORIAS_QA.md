# Melhorias de QA — 07/10/2026

## Implementação

- API de ícones dos botões corrigida para Godot 4.3.
- Pausa e overlays bloqueiam escolhas, movimento e foco dos alvos do mundo.
- Save v2 valida esquema, versões e IDs; grava temporário, conserva backup e restaura posição, direção, diálogo e histórico. Saves v1 válidos continuam aceitos. Load inválido preserva a sessão atual.
- Checkpoint antes da ação/escolha permite retomar após um final sem apagar finais/conquistas registrados.
- Hotspots de Documentação, Jurídico e Diretoria recalibrados. OS colocada no bolso; apenas o alvo ativo é exibido. HUD e menus deixam de ser alvos de caminhada.
- Inventário indica seleção e disfarce. Cancelamento pelo botão ou clique direito. Ícones individuais para Ficha RH, Assinatura RH e Bolota pendente.
- Diário (D), objetivo, histórico, checklist de RH/Jurídico, mapa, pendências nomeadas e dicas em três níveis.
- Falas com duração proporcional, avanço por clique/Espaço/Enter, tempo ajustável e pausa da leitura durante overlays.
- Fonte ajustável, alto contraste, movimento reduzido e ajuda de hotspots. Botões usam navegação por Tab/Shift+Tab e confirmação por Enter/Espaço.
- Caminhos por cenário, obstáculos, aproximação dos alvos e caches do protagonista/subáreas. Ganho de FPS não foi medido. Ainda há autoloads de apresentação que atualizam componentes a cada frame; a centralização completa permanece trabalho de arquitetura.
- Comunicação exige conhecer o centro de custo; Financeiro exige explicar vínculo e destinatário. Escolhas explícitas precedem os riscos terminais dos departamentos revisados.
- Atalho do Auditório chega ao RH com retorno; registro Pouco colaborativo tem consequência no RH. Backtracking preserva a Bolota aprovada.
- Todos os 30 finais e as 22 conquistas possuem gatilhos exercitados. Pizza perdida, sem fatias ou sem integridade não permite sucesso.
- Trilha ausente substituída pelo tema existente da Recepção; andares posteriores usam fallback. Sons sintetizados para coleta, conquista e final respeitam volume. A Sala de Sistemas reutiliza temporariamente a arte da Sala de Servidores.
- README e unidades da pizza reconciliados com o código. A Diretoria preserva a pergunta exclusiva sobre Ronaldo Gilberto.

## Validação reproduzível

Godot 4.3, cena e autoloads reais, dados de usuário isolados. A suíte cobre campanha principal, negativos, saves, posição/diálogo, pausa, inventário, teclado, geometria, obstáculos, backtracking e coleções completas. Usa handlers reais e injeção de eventos; não constitui playthrough completo por mouse ou certificação de navegador.

```sh
# Linux: execute com diretório de usuário isolado, nunca com partidas pessoais.
export XDG_DATA_HOME="$(mktemp -d)"
godot --headless --editor --path godot --quit
godot --headless --fixed-fps 60 --path godot res://qa/QA.tscn
python3 godot/qa/check_results.py
```

A suíte usa slots 0, 95 e 96; os dados de QA não devem substituir saves pessoais. A pasta `qa/` não integra a exportação. O workflow GitHub Actions executa a regressão em cada push/PR e falha também se houver erros no log.

A rodada reconstruída satisfez **149/149 verificações**, sem erros de script/runtime no log. Inclui ativação de botão por Enter e clique enviado ao viewport em coordenadas locais. A exportação Web release local concluiu.

## Limites e próximos aceites

Ainda requer playtest visual nas resoluções alvo, caminho inteiro por mouse, navegador/reload/storage, áudio ouvido em dispositivo, sessão longa e balanceamento com iniciantes. A exportação local não certifica o deploy Render. O limite de 150 minutos foi preservado; custos de inspeções/subáreas ainda precisam de balanceamento consistente baseado em playtest.

## Recuperação da entrega

O commit local da primeira implementação foi removido pela manutenção automática antes do envio autorizado. Esta branch reconstrói as mudanças e tem uma nova rodada de validação; não usa o SHA nem a contagem de testes daquela execução como prova da versão atual.
