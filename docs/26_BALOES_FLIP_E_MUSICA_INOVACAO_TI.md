# Balões com flip e música — Inovação / TI

## Balões de fala

- Balões próximos da borda direita passam a abrir para a esquerda do hotspot.
- A arte do balão recebe flip horizontal, mantendo o texto legível.
- Balões próximos da borda esquerda usam o comportamento inverso.
- O deslocamento fino específico da Recepção (`RECEPTION_SPEECH_IMAGE_DELTA`) não é mais aplicado às outras áreas.
- Isso preserva as âncoras reais dos hotspots do Auditório, Inovação, TI e Comunicação e evita cortes de tela, especialmente no Banheiro da Inovação e em Rogério Wilco.

## Óculos VR em Rogério Wilco

- Após derrotar o chefe da TI, o item `vr_glasses` sai do inventário.
- A sprite dos óculos aparece no rosto de Rogério.
- A sprite foi aumentada e recebe flip horizontal para combinar melhor com o rosto/personagem.

## Música compartilhada

`MusicManager` agora possui o modo `innovation_ti` e espera o arquivo:

`res://assets/audio/innovation_ti_theme.ogg`

A mesma faixa é usada nas áreas:

- `innovation`
- `innovation_meeting_room`
- `ti`
- `ti_server_room`
- `ti_service_desk`

A faixa usa o mesmo sistema global de fade, volume e loop já usado no menu e na Recepção.

O áudio enviado foi convertido para Ogg Vorbis, 48 kHz, estéreo, duração aproximada de 98,8 segundos. O binário deve ser colocado no caminho acima; o conector GitHub usado nesta sessão aceita somente arquivos UTF-8 e não consegue gravar diretamente binários de áudio.
