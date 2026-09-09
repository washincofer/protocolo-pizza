# Calibração visual e de hotspots

Ferramentas temporárias da fase de polimento do point-and-click.

## Atalhos

- **F1 — HUD**: mostra/oculta HUD, inventário, caixa de diálogo e botão de pausa.
- **F2 — Hotspots**: mostra/oculta o contorno de depuração dos hotspots. Os hotspots continuam clicáveis quando o contorno está oculto.
- **F3 — Coordenadas**: mostra/oculta um painel com coordenadas do mouse.

O painel F3 informa:

- **Tela X/Y** — posição no viewport atual;
- **Imagem X/Y** — posição convertida para a resolução original da arte.

Para corrigir hotspots, usar sempre **Imagem X/Y**, pois esses valores não mudam quando o navegador ou a janela muda de tamanho.

## Como reportar um hotspot desalinhado

Exemplo:

```text
Área: Recepção
Hotspot: Eliana Marli / Balcão
Canto superior esquerdo: Imagem X=510 Y=275
Canto inferior direito: Imagem X=810 Y=535
```

Com esses dois pontos, o retângulo fica:

```text
[x, y, largura, altura]
[510, 275, 300, 260]
```

## Escala de cenário

A build usa `canvas_items` + aspecto `keep` e também aplica uma margem segura ao cenário. O objetivo é preservar a arte inteira na tela, usando letterbox/pillarbox quando necessário, sem cortar partes importantes.

## Próxima etapa

Depois de alinhar os hotspots das áreas principais, serão criadas e integradas as subáreas/salas extras já definidas na documentação canônica.
