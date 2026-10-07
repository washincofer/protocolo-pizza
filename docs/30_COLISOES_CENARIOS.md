# Colisões dos cenários — 07/10/2026

As 22 áreas jogáveis passaram por inspeção visual dos backgrounds de 1672×941. São 21 imagens distintas: a Sala de Sistemas reutiliza a imagem da Sala de Servidores e compartilha sua geometria. A tela de menu foi inspecionada; não tem personagem caminhando.

O personagem agora anda dentro de contornos do piso e contorna 116 polígonos de objetos sólidos. Paredes, divisórias e limites do cenário ficam fora do piso navegável. Balcões, mesas, sofás, cadeiras, catracas, pedestais, equipamentos, caixas e vasos receberam bloqueios próprios. Tapetes, faixas pintadas e grelhas planas continuam transitáveis.

## Mapeamento por área

| Área | Principais bloqueios |
| --- | --- |
| Recepção | Balcão, totem, catracas, posto, elevadores, escadas, estátua e vasos |
| Sala de Espera | Sofá, mesa de revistas, revisteiro, água, lixeira, posto e vasos |
| Auditório | Palco, fileiras de cadeiras, mesa de café, Lúcia, livros e bolsas |
| Inovação | Mesas de protótipos, cadeira, lixeira, pufes, água, pia e vasos |
| Sala de Reunião | Mesa central, três cadeiras frontais, pufes, café e caixas |
| TI | Balcão, estações, divisória de vidro, mesa de Rogério, técnico, equipamentos e sofá |
| Servidores / Sistemas | Racks, mesa de monitoramento, cadeira, ferramentas, nobreak, caixas e cabos |
| Service Desk | Balcão, totem, lixeira, cordões e bases da fila, sofás e vasos |
| Comunicação | Sofá, mesas de café, estante, divisória do estúdio, planejamento, pebolim, impressora e pufe |
| Suprimentos | Balcão, carrinhos, impressora, arquivo, mesa, caixas e plantas |
| Hall | Banco, mesa, painel com jardineira, bebedouro, lixeira e vasos |
| Financeiro | Mesas de atendimento, impressora, lixeira e mesas em primeiro plano |
| Engenharia | Bancada, carrinho do colete, bancada de ferramentas, cones, placa e plantas |
| Vigilância | Catracas, braços, balcão, esteira, detector, lixeira e sofá |
| RH | Balcão, sofá, mesa, arquivos, balcão de terceiros, copa e mesas frontais |
| Controle de Ponto | Sofá, mesa, relógio, lixeira, balcão, café e vasos |
| Cadastro de Terceiros | Balcão, bancada de documentos, copa, lixeira, mesa e cadeiras |
| Documentação | Arquivo, balcão, senhas, Bolota, mesas de digitalização, carrinho, impressora e parede das escadas |
| Arquivo / Reprografia | Impressora, carrinho de papéis, estantes, balcão, carrinho de caixas e processos |
| Jurídico | Sofá, recepção, estátua, análise, carimbo, contratos, lixeira e vasos |
| Diretoria | Sofá, revistas, balcão de Carla, pedestal, água, livros e vasos |

## Comportamento e manutenção

- `godot/scripts/walkable_geometry.gd` contém os contornos medidos, nomes dos sólidos, posições iniciais e pontos de aproximação das interações.
- `walkable_catalog.gd` reduz o piso e amplia os sólidos em 12 pixels para dar espaço aos pés. Usa uma rede de caminhos com cantos de obstáculos, inclusive onde objetos encostam entre si ou numa parede. A rede é calculada uma vez por área.
- Cliques em superfícies bloqueadas procuram o piso livre mais próximo. Se não houver caminho, o personagem para e a interação não é executada. Um clique não pode atravessar uma parede.
- Interações têm aproximações no piso; nos cenários com mobiliário cobrindo um acesso, a ação usa o ponto livre diante desse conjunto. Entradas em subáreas e escadas continuam sendo transições por hotspot.
- A caminhada verifica cada deslocamento. A opção de movimento reduzido usa o destino corrigido da rota, inclusive ao clicar em móveis. Saves antigos dentro de novos bloqueios recebem uma posição livre antes da retomada.
- Os limites usam coordenadas da imagem, acompanhando o enquadramento do background. A referência de posição é a base do personagem, como em uma aventura point-and-click com perspectiva. Não há simulação de corpos rígidos.

**F4** liga/desliga a visualização dentro do jogo: piso em verde, sólidos em vermelho, pés em amarelo e rota em azul claro. A camada acompanha mudanças de cenário e não intercepta cliques. F1/F2/F3 mantêm HUD, hotspots e coordenadas.

## Validação

403/403 verificações no Godot 4.3. Incluem a campanha e regressões anteriores, 22 posições iniciais, sondas visuais de paredes e móveis, amostragem de conectividade do piso, rotas até todos os hotspots ativos, amostragem dos segmentos a cada quatro pixels, saves antigos, movimento reduzido, caminhada animada, clique numa parede, entradas/retornos das subáreas e F4. Importação e exportação Web release local concluídas.

A revisão visual sobrepôs os contornos calculados pelo Godot às imagens originais. A suíte grava `godot/qa/collision_maps.json`, ignorado pelo Git; o comando abaixo gera imagens de inspeção fora do repositório. O renderizador opcional precisa de Pillow; a suíte Godot e o CI não dependem dele.

```sh
godot --headless --editor --path godot --quit
godot --headless --fixed-fps 60 --path godot res://qa/QA.tscn
python3 godot/qa/check_results.py
python3 godot/qa/render_collision_maps.py /tmp/pizza-collision-maps --routes
```

Os testes automatizados e a revisão dos mapas não substituem o playtest completo no navegador/Render. Caso a posição dos objetos mude numa arte, recalibrar o catálogo e revisar F4 antes de publicar a nova imagem.
