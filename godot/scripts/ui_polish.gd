extends Node

const UIAssets = preload("res://scripts/ui_asset_catalog.gd")

const MENU_RECTS := {
	"Novo Jogo": Rect2(928, 321, 329, 122),
	"Save / Load": Rect2(928, 464, 329, 95),
	"Opções": Rect2(928, 574, 329, 117)
}

var pause_layer: CanvasLayer
var inventory_layer: CanvasLayer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	process_priority = 100
	set_process(true)

func _unhandled_key_input(event: InputEvent) -> void:
	var key_event: InputEventKey = event as InputEventKey
	if key_event == null or not key_event.pressed or key_event.echo:
		return
	if AchievementsUI.overlay_layer != null:
		return
	if key_event.keycode == KEY_ESCAPE and GameState.run_active:
		if inventory_layer != null:
			_close_inventory()
		elif pause_layer != null:
			_close_pause()
		else:
			_open_pause()
		get_viewport().set_input_as_handled()

func _process(_delta: float) -> void:
	var main: Control = _get_main()
	if main == null:
		return
	if GameState.run_active:
		_hide_inline_inventory(main)
	else:
		_apply_menu_hotspots(main)

func _get_main() -> Control:
	var current: Node = get_tree().current_scene
	if current is Control:
		return current as Control
	return null

func _find_background(main: Control) -> TextureRect:
	for child: Node in main.get_children():
		if child is TextureRect:
			var rect: TextureRect = child as TextureRect
			if rect.texture != null:
				return rect
	return null

func _is_hotspot_button(node: Node) -> bool:
	if not (node is Button):
		return false
	var button: Button = node as Button
	return button.text == "" and button.tooltip_text != ""

func _apply_menu_hotspots(main: Control) -> void:
	var bg: TextureRect = _find_background(main)
	if bg == null or bg.texture == null:
		return
	var source_size: Vector2 = Vector2(bg.texture.get_size())
	if source_size.x <= 0.0 or source_size.y <= 0.0 or bg.size.x <= 0.0 or bg.size.y <= 0.0:
		return
	var sx: float = bg.size.x / source_size.x
	var sy: float = bg.size.y / source_size.y
	for child: Node in main.get_children():
		if not _is_hotspot_button(child):
			continue
		var button: Button = child as Button
		if not MENU_RECTS.has(button.tooltip_text):
			continue
		var source_rect: Rect2 = MENU_RECTS[button.tooltip_text]
		button.position = bg.position + Vector2(source_rect.position.x * sx, source_rect.position.y * sy)
		button.size = Vector2(source_rect.size.x * sx, source_rect.size.y * sy)

func _hide_inline_inventory(main: Control) -> void:
	var view_height: float = get_viewport().get_visible_rect().size.y
	for child: Node in main.get_children():
		if child is PanelContainer:
			var panel: PanelContainer = child as PanelContainer
			var is_inventory: bool = panel.position.x <= 30.0 and panel.position.y >= view_height - 190.0 and panel.size.x <= 210.0
			if is_inventory:
				panel.visible = false

func _overlay_style() -> StyleBoxFlat:
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = Color(0.03, 0.06, 0.09, 0.95)
	style.border_color = Color(1.0, 0.78, 0.18, 0.78)
	style.set_border_width_all(2)
	style.corner_radius_top_left = 16
	style.corner_radius_top_right = 16
	style.corner_radius_bottom_left = 16
	style.corner_radius_bottom_right = 16
	return style

func _open_pause() -> void:
	_close_pause()
	pause_layer = CanvasLayer.new()
	pause_layer.layer = 1000
	add_child(pause_layer)

	var shade: ColorRect = ColorRect.new()
	shade.color = Color(0, 0, 0, 0.72)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	pause_layer.add_child(shade)

	var center: CenterContainer = CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	pause_layer.add_child(center)

	var panel: PanelContainer = PanelContainer.new()
	panel.custom_minimum_size = Vector2(520, 0)
	panel.add_theme_stylebox_override("panel", _overlay_style())
	center.add_child(panel)

	var box: VBoxContainer = VBoxContainer.new()
	box.add_theme_constant_override("separation", 10)
	panel.add_child(box)

	var title: Label = Label.new()
	title.text = "PAUSA"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 30)
	title.add_theme_color_override("font_color", Color("ffd34e"))
	box.add_child(title)

	_add_pause_button(box, "Inventário", _open_inventory)
	_add_pause_button(box, "Conquistas", _open_achievements)
	_add_pause_button(box, "Salvar / Carregar", _call_main.bind("_open_save_load"))
	_add_pause_button(box, "Opções", _call_main.bind("_open_options"))
	_add_pause_button(box, "Voltar ao jogo", _close_pause)
	_add_pause_button(box, "Menu principal", _go_main_menu)
	_add_pause_button(box, "Sair do jogo", _quit_game)

func _add_pause_button(box: VBoxContainer, label_text: String, callback: Callable) -> void:
	var button: Button = Button.new()
	button.text = label_text
	button.custom_minimum_size = Vector2(420, 50)
	button.add_theme_font_size_override("font_size", 19)
	button.pressed.connect(callback)
	box.add_child(button)

func _close_pause() -> void:
	if pause_layer != null:
		pause_layer.queue_free()
		pause_layer = null

func reopen_pause() -> void:
	if GameState.run_active:
		_open_pause()

func _open_achievements() -> void:
	_close_pause()
	AchievementsUI.open(true)

func _open_inventory() -> void:
	_close_pause()
	_close_inventory()
	inventory_layer = CanvasLayer.new()
	inventory_layer.layer = 1010
	add_child(inventory_layer)

	var shade: ColorRect = ColorRect.new()
	shade.color = Color(0, 0, 0, 0.76)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	inventory_layer.add_child(shade)

	var center: CenterContainer = CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	inventory_layer.add_child(center)

	var panel: PanelContainer = PanelContainer.new()
	panel.custom_minimum_size = Vector2(650, 0)
	panel.add_theme_stylebox_override("panel", _overlay_style())
	center.add_child(panel)

	var box: VBoxContainer = VBoxContainer.new()
	box.add_theme_constant_override("separation", 10)
	panel.add_child(box)

	var title: Label = Label.new()
	title.text = "INVENTÁRIO"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 30)
	title.add_theme_color_override("font_color", Color("ffd34e"))
	box.add_child(title)

	var hint: Label = Label.new()
	hint.text = "Selecione um item e depois clique no alvo do cenário. O Colete é vestido diretamente aqui."
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(hint)

	if GameState.inventory.is_empty():
		var empty: Label = Label.new()
		empty.text = "Inventário vazio."
		empty.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		empty.add_theme_font_size_override("font_size", 20)
		box.add_child(empty)
	else:
		for item: Variant in GameState.inventory:
			var item_id: String = str(item)
			var button: Button = Button.new()
			if item_id == "maintenance_vest":
				button.text = "Colete de Manutenção (vestido)" if GameState.disguise == "maintenance" else "Vestir Colete de Manutenção"
			else:
				button.text = _item_name(item_id)
			var item_texture: Texture2D = UIAssets.item_texture(item_id)
			if item_texture != null:
				button.icon = item_texture
				button.icon_max_width = 42
			button.custom_minimum_size = Vector2(520, 52)
			button.pressed.connect(_select_inventory_item.bind(item_id))
			box.add_child(button)

	var back: Button = Button.new()
	back.text = "Voltar"
	back.custom_minimum_size = Vector2(520, 44)
	back.pressed.connect(_back_to_pause)
	box.add_child(back)

func _item_name(item_id: String) -> String:
	var names: Dictionary = {
		"visitor_badge": "Crachá de Visitante",
		"vr_glasses": "Óculos VR",
		"executive_priority_stamp": "Carimbo — Prioridade Executiva",
		"third_party_proof": "Comprovante de Prestador Terceirizado",
		"fiscal_exception_protocol": "Protocolo de Exceção Fiscal",
		"maintenance_vest": "Colete de Manutenção",
		"work_order": "Ordem de Serviço (OS)",
		"third_party_form": "Ficha de Validação de Terceiro",
		"rh_validation_signature": "Assinatura de Validação do RH",
		"legal_bolota_pending": "Bolota do Jurídico — Pendente",
		"legal_bolota_approved": "Bolota do Jurídico — Aprovada"
	}
	return str(names.get(item_id, item_id))

func _select_inventory_item(item_id: String) -> void:
	var main: Control = _get_main()
	if item_id == "maintenance_vest":
		GameFlow.equip_item(item_id)
		if main != null:
			main.set("selected_item", "")
			main.set("feedback_text", "Colete de Manutenção vestido. Agora selecione a Ordem de Serviço para apresentar à Vigilância.")
		_close_inventory()
		return
	if main != null:
		main.set("selected_item", item_id)
		main.set("feedback_text", "Selecionado: %s. Agora clique no alvo do cenário." % _item_name(item_id))
	_close_inventory()

func _close_inventory() -> void:
	if inventory_layer != null:
		inventory_layer.queue_free()
		inventory_layer = null

func _back_to_pause() -> void:
	_close_inventory()
	_open_pause()

func _call_main(method_name: String) -> void:
	_close_pause()
	if DialogueUI.is_open():
		DialogueUI.close_dialogue()
	var main: Control = _get_main()
	if main != null and main.has_method(method_name):
		main.call(method_name)

func _go_main_menu() -> void:
	_close_pause()
	_close_inventory()
	if DialogueUI.is_open():
		DialogueUI.close_dialogue()
	DialogueUI.close_speech()
	GameState.reset_run(false)
	var main: Control = _get_main()
	if main != null and main.has_method("show_menu"):
		main.call("show_menu")
		_apply_menu_hotspots(main)

func _quit_game() -> void:
	_close_pause()
	_close_inventory()
	if DialogueUI.is_open():
		DialogueUI.close_dialogue()
	DialogueUI.close_speech()
	GameState.run_active = false
	get_tree().quit()
