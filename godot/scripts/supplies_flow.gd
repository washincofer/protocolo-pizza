extends Node

const AREA_ID: String = "supplies"
const TARGETS: Dictionary = {
	"Stan Leilo / Aprovação de Compras": "stan",
	"Três Cotações": "quotes",
	"Almoxarifado": "warehouse",
	"Sala de Compras": "supplier",
	"Saída — Comunicação / Hall": "exit"
}

const STAN_ANCHOR: Vector2 = Vector2(607.0, 405.0)
const QUOTES_ANCHOR: Vector2 = Vector2(405.0, 320.0)
const WAREHOUSE_ANCHOR: Vector2 = Vector2(1378.0, 185.0)
const SUPPLIER_ANCHOR: Vector2 = Vector2(90.0, 105.0)
const EXIT_ANCHOR: Vector2 = Vector2(865.0, 845.0)

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	process_priority = 250
	DialogueUI.choice_selected.connect(_on_dialogue_choice)
	set_process(true)

func _process(_delta: float) -> void:
	if not GameState.run_active or GameState.current_area != AREA_ID:
		return
	var main: Control = _get_main()
	if main == null:
		return
	_patch_supplies_hotspots(main)

func _get_main() -> Control:
	var current: Node = get_tree().current_scene
	if current is Control:
		return current as Control
	return null

func _find_hotspot(main: Control, tooltip: String) -> Button:
	for child: Node in main.get_children():
		var button: Button = child as Button
		if button != null and button.text == "" and button.tooltip_text == tooltip:
			return button
	return null

func _patch_supplies_hotspots(main: Control) -> void:
	for tooltip_value: Variant in TARGETS.keys():
		var tooltip: String = str(tooltip_value)
		var original: Button = _find_hotspot(main, tooltip)
		if original == null:
			continue
		original.disabled = true
		original.mouse_filter = Control.MOUSE_FILTER_IGNORE

		var overlay_name: String = "SuppliesFlow_%s" % tooltip.replace(" ", "_").replace("/", "_").replace("—", "_")
		var overlay: Button = main.get_node_or_null(overlay_name) as Button
		if overlay == null:
			overlay = _transparent_button(tooltip)
			overlay.name = overlay_name
			overlay.z_index = 65
			var action: String = str(TARGETS.get(tooltip, ""))
			overlay.pressed.connect(_handle_action.bind(action))
			main.add_child(overlay)
		overlay.position = original.position
		overlay.size = original.size

func _transparent_button(tooltip: String) -> Button:
	var button: Button = Button.new()
	button.text = ""
	button.tooltip_text = tooltip
	button.focus_mode = Control.FOCUS_NONE
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	var normal: StyleBoxFlat = StyleBoxFlat.new()
	normal.bg_color = Color(1, 1, 1, 0)
	normal.border_color = Color(1, 1, 1, 0)
	button.add_theme_stylebox_override("normal", normal)
	var hover: StyleBoxFlat = StyleBoxFlat.new()
	hover.bg_color = Color(1.0, 0.82, 0.2, 0.08)
	hover.border_color = Color(1.0, 0.82, 0.2, 0.95)
	hover.set_border_width_all(3)
	hover.corner_radius_top_left = 10
	hover.corner_radius_top_right = 10
	hover.corner_radius_bottom_left = 10
	hover.corner_radius_bottom_right = 10
	button.add_theme_stylebox_override("hover", hover)
	button.add_theme_stylebox_override("pressed", hover)
	return button

func _handle_action(action: String) -> void:
	if not GameState.run_active or GameState.current_area != AREA_ID:
		return
	GameState.tick(2)
	match action:
		"stan":
			_handle_stan()
		"quotes":
			_open_quotes_dialogue()
		"warehouse":
			_open_warehouse_dialogue()
		"supplier":
			_open_supplier_dialogue()
		"exit":
			_open_navigation()

func _handle_stan() -> void:
	if GameState.has_flag("boss_supplies_done"):
		_show_near("Stan Leilo", "Compra emergencial já aprovada. Milagre administrativo não se repete no mesmo protocolo.", STAN_ANCHOR)
		return
	var main: Control = _get_main()
	var selected_value: Variant = main.get("selected_item") if main != null else ""
	var selected_item: String = str(selected_value)
	if selected_item != "executive_priority_stamp":
		_show_near("Stan Leilo", "Prioridade sem carimbo não é prioridade.", STAN_ANCHOR)
		return
	if not GameState.knows("cc_0001"):
		_show_near("Stan Leilo", "E o centro de custo?", STAN_ANCHOR)
		return
	GameState.set_flag("boss_supplies_done")
	AchievementManager.unlock("Compra emergencial")
	if main != null:
		main.set("selected_item", "")
	_show_near("Stan Leilo", "JUSTIFICATIVA: FOME. Compra emergencial aprovada — PROCESSO CONTORNADO. A saída para o Hall está liberada.", STAN_ANCHOR)

func _open_quotes_dialogue() -> void:
	DialogueUI.open_dialogue(
		"supplies_patch_quotes",
		"Três Cotações",
		"O sistema achou três fornecedores. Um é R$ 2 mais barato e ninguém sabe exatamente por quê.",
		[
			{"id":"A","key":"A","text":"Escolher o menor preço. Dois reais são dois reais."},
			{"id":"B","key":"B","text":"Comparar escopo, prazo e qualidade antes."},
			{"id":"C","key":"C","text":"Fechar a planilha antes que ela peça uma quarta cotação."}
		],
		QUOTES_ANCHOR
	)

func _open_warehouse_dialogue() -> void:
	DialogueUI.open_dialogue(
		"supplies_patch_warehouse",
		"Murray Estoque — Almoxarifado",
		"Tem espaço na quarentena. Quer deixar a pizza para conferência e inventário?",
		[
			{"id":"A","key":"A","text":"Sim. Pode guardar e conferir com calma."},
			{"id":"B","key":"B","text":"Não. É perecível e já tem destinatário."},
			{"id":"C","key":"C","text":"Só se você assinar responsabilidade pela temperatura."}
		],
		WAREHOUSE_ANCHOR
	)

func _open_supplier_dialogue() -> void:
	DialogueUI.open_dialogue(
		"supplies_patch_supplier",
		"Sala de Compras",
		"Para homologar o fornecedor precisamos de uma amostra do produto. De preferência triangular.",
		[
			{"id":"A","key":"A","text":"Entregar uma fatia para degustação técnica."},
			{"id":"B","key":"B","text":"O fornecedor é a pizzaria. Eu só sou o entregador."},
			{"id":"C","key":"C","text":"Pedir o formulário de homologação e recuar lentamente."}
		],
		SUPPLIER_ANCHOR
	)

func _open_navigation() -> void:
	var choices: Array = [
		{"id":"A","key":"A","text":"Voltar para Comunicação."}
	]
	if GameState.has_flag("boss_supplies_done"):
		choices.append({"id":"B","key":"B","text":"Avançar para o Hall Corporativo."})
	DialogueUI.open_dialogue(
		"supplies_patch_navigation",
		"Saída de Suprimentos",
		"A porta não decide por você. O processo quase decide.",
		choices,
		EXIT_ANCHOR
	)

func _on_dialogue_choice(dialogue_id: String, choice_id: String) -> void:
	if not GameState.run_active:
		return
	match dialogue_id:
		"supplies_patch_quotes":
			match choice_id:
				"A":
					AchievementManager.unlock("Economia de R$ 2")
					_finish("MENOR PREÇO", "Sua pizza perdeu a concorrência por dois reais.")
				"B":
					_show_near("Três Cotações", "Você tentou comparar escopo e qualidade. A planilha marcou isso como comportamento inovador e suspeito.", QUOTES_ANCHOR)
				"C":
					_show_near("Três Cotações", "Planilha fechada com sucesso. Nenhuma célula foi ferida.", QUOTES_ANCHOR)
		"supplies_patch_warehouse":
			match choice_id:
				"A":
					_finish("MATERIAL RETIDO", "Murray Estoque colocou a pizza em quarentena administrativa.")
				"B":
					_show_near("Murray Estoque", "Perecível e com destinatário? Estranhamente, isso faz sentido. Pode levar.", WAREHOUSE_ANCHOR)
				"C":
					_show_near("Murray Estoque", "Assinar responsabilidade? Não, não. Melhor a pizza continuar sob sua custódia.", WAREHOUSE_ANCHOR)
		"supplies_patch_supplier":
			match choice_id:
				"A":
					_finish("FORNECEDOR HOMOLOGADO", "A degustação técnica aprovou o produto e consumiu a evidência.")
				"B":
					_show_near("Sala de Compras", "Tecnicamente correto. Você escapou de ser homologado como fornecedor de si mesmo.", SUPPLIER_ANCHOR)
				"C":
					_show_near("Sala de Compras", "Formulário SC-47 entregue. São 11 páginas. Você decide não criar esse problema hoje.", SUPPLIER_ANCHOR)
		"supplies_patch_navigation":
			if choice_id == "A":
				SceneRouter.route_to("communication")
			elif choice_id == "B" and GameState.has_flag("boss_supplies_done"):
				SceneRouter.route_to("hall")

func _show_near(speaker: String, text: String, anchor: Vector2) -> void:
	DialogueUI.show_speech(speaker, text, anchor)

func _finish(ending_name: String, message: String) -> void:
	EndingManager.register(ending_name)
	GameState.run_active = false
	GameFlow.finished.emit(ending_name, message)
