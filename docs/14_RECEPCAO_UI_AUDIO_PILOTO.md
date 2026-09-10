# PROTOCOLO: PIZZA — Piloto visual e áudio da Recepção

Status: **CÓDIGO IMPLEMENTADO / ASSETS BINÁRIOS PENDENTES DE UPLOAD**

## Objetivo

Usar a Recepção como área piloto para validar a nova linguagem de interface do jogo:

- música própria da área;
- balões de fala pequenos, médios e grandes;
- escolhas A/B/C/D em duas colunas na HUD inferior;
- ícones visuais de troféu, menu e pizza;
- ícones dos principais itens coletáveis no inventário.

## Estrutura esperada de assets

```text
godot/
└── assets/
    ├── audio/
    │   └── reception_theme.ogg
    └── ui/
        ├── speech/
        │   ├── speech_small.png
        │   ├── speech_medium.png
        │   └── speech_large.png
        ├── dialogue/
        │   ├── choice_panel.png
        │   ├── button_a.png
        │   ├── button_b.png
        │   ├── button_c.png
        │   └── button_d.png
        ├── icons/
        │   ├── trophy.png
        │   ├── menu.png
        │   └── pizza.png
        └── items/
            ├── vr_glasses.png
            ├── maintenance_vest.png
            ├── work_order.png
            ├── visitor_badge.png
            ├── executive_priority_stamp.png
            ├── fiscal_exception_protocol.png
            ├── legal_bolota_approved.png
            └── third_party_proof.png
```

## Comportamento implementado

### Música

`MusicManager` agora usa:

- `menu_intro.ogg` no menu principal;
- `reception_theme.ogg` em `reception`, `reception_waiting_room` e `reception_auditorium`;
- fade entre menu e Recepção;
- loop da faixa OGG;
- fallback silencioso caso o arquivo ainda não esteja no repositório.

### Diálogo

`DialogueUI` agora possui três tamanhos automáticos de balão:

- pequeno: até 75 caracteres;
- médio: 76 a 180 caracteres;
- grande: acima de 180 caracteres.

Na Recepção, Eliana Marli, Mauro Portela e o Totem possuem posições padrão para os balões.

### Escolhas

Quando um diálogo possui opções, o painel inferior usa o layout:

```text
A - opção 1                 B - opção 2
C - opção 3                 D - opção 4
```

O jogador pode clicar nas opções ou usar as teclas `A`, `B`, `C` e `D`.

### HUD

O topo da tela foi preparado para usar:

- ícone de pizza junto do percentual/tempo;
- ícone de troféu para abrir Conquistas;
- ícone de menu para abrir o mesmo menu de pausa usado pelo `Esc`.

Na Recepção, o antigo painel inferior de texto fica oculto para testar os balões.

### Inventário

O inventário do `Esc` tenta carregar automaticamente os ícones dos itens através de `ui_asset_catalog.gd`. Quando um item ainda não possui arte, o botão textual continua funcionando normalmente.

## Arquivos de código envolvidos

- `godot/scripts/music_manager.gd`
- `godot/scripts/dialogue_ui.gd`
- `godot/scripts/ui_asset_catalog.gd`
- `godot/scripts/main.gd`
- `godot/scripts/ui_polish.gd`
- `godot/scripts/interaction_guard.gd`
- `godot/scripts/debug_tools.gd`

## Upload manual dos binários

O conector de GitHub usado pelo ChatGPT atualiza arquivos de texto, mas não envia os PNG/OGG binários. Portanto, os assets precisam ser enviados manualmente.

### Pelo site do GitHub

1. Baixe e extraia `PROTOCOLO_PIZZA_RECEPCAO_UI_AUDIO_PACK.zip`.
2. Abra o repositório `washincofer/protocolo-pizza` no GitHub.
3. Entre na pasta `godot`.
4. Use **Add file → Upload files**.
5. Arraste a pasta `assets` de dentro da pasta `godot` do pacote, preservando os caminhos apresentados acima. Se o navegador não aceitar a pasta inteira, envie os arquivos nas respectivas pastas.
6. Confirme que `reception_theme.ogg` ficou em `godot/assets/audio/`.
7. Confirme que os PNGs ficaram em `godot/assets/ui/...`.
8. Use a mensagem de commit: `Adiciona assets de UI e trilha da Recepção`.
9. Faça o commit diretamente em `main`.

### Pelo Git local

Depois de copiar a pasta `godot` do pacote para a raiz do repositório:

```bash
git status
git add godot/assets/audio/reception_theme.ogg godot/assets/ui
git commit -m "Adiciona assets de UI e trilha da Recepção"
git push origin main
```

## Teste mínimo após deploy

1. Abrir o menu e iniciar novo jogo.
2. Confirmar fade da música do menu para a música da Recepção.
3. Clicar em Eliana e validar balão + painel A/B/C/D.
4. Testar também as teclas A/B/C/D.
5. Clicar no Segurança e no Totem e confirmar balões automáticos.
6. Após receber o crachá, abrir `Esc → Inventário` e confirmar o ícone do item.
7. Confirmar os ícones de Pizza, Troféu e Menu na HUD superior.
8. Pressionar F1 e confirmar que a HUD visual desaparece/reaparece normalmente.
9. Abrir o menu pelo ícone e pelo Esc e confirmar que ambos abrem a mesma interface de pausa.
