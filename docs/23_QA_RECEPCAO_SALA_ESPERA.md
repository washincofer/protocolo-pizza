# QA — Recepção e Sala de Espera

Estado: base aprovada para servir como padrão de qualidade das próximas áreas.

## Correções aplicadas

### Progressão da Recepção
A Escada só libera a passagem para Inovação quando o jogador:
1. estiver identificado na Recepção; e
2. tiver mostrado o crachá ao Mauro Portela, gerando `security_cleared`.

Isso impede que o posto de Segurança seja ignorado na rota normal.

### Hotspots de debug
A visualização de hotspots inicia desligada (`F2 = OFF`).
O recurso continua disponível para calibração, mas não aparece por padrão para o jogador.

### Tempo na Sala de Espera
Cada interação com o grupo de visitantes consome 2 minutos por meio de `GameState.tick(2)`.
Assim, explorar o diálogo tem consequência real sobre tempo e temperatura da pizza.
O quarto clique continua levando ao final `VISITANTE RETIRADO`.

### Subáreas no catálogo de cenários
As oito subáreas atuais agora possuem entrada própria de tamanho, background e título no `HotspotCatalog`:
- Recepção — Sala de Espera
- Recepção — Auditório / Onboarding
- Inovação — Sala de Reunião
- TI — Sala de Servidores
- TI — Service Desk
- RH — Controle de Ponto
- RH — Cadastro de Terceiros
- Documentação — Arquivo / Reprografia

O `Main` passa a carregar diretamente a imagem correta da subárea, em vez de usar temporariamente o fallback da Recepção e aguardar o `SubareaManager` substituir a textura.

## Regressão a verificar em jogo

1. Novo Jogo -> Eliana -> opção A.
2. Tentar Escadas antes da Segurança: deve bloquear.
3. Falar com Mauro: deve liberar `security_cleared`.
4. Escadas: deve seguir para Inovação.
5. F2 deve iniciar desligado e alternar normalmente.
6. Entrar na Sala de Espera: a imagem correta deve aparecer diretamente.
7. Conversar com Visitantes 1, 2 e 3: +2 minutos em cada conversa.
8. Quarto clique: final `VISITANTE RETIRADO`.
9. Voltar à Recepção: hotspots e movimento devem continuar funcionais.

## Regra de projeto

Recepção e Sala de Espera ficam congeladas como padrão ouro de implementação. Mudanças futuras nessas áreas devem ser apenas correção de bug, calibração pontual ou polimento explicitamente aprovado.
