extends Node

const UIAssets = preload("res://scripts/ui_asset_catalog.gd")

const PANEL_SHEET_PATH: String = "res://assets/ui/menus/menu_panels.png"
const PANEL_REGIONS: Dictionary = {
	"pause": Rect2(16.0, 6.0, 485.0, 618.0),
	"inventory": Rect2(517.0, 36.0, 487.0, 580.0),
	"trophies": Rect2(1026.0, 44.0, 420.0, 577.0),
	"save_load": Rect2(65.0, 626.0, 627.0, 446.0),
	"options": Rect2(744.0, 628.0, 636.0, 448.0)
}

var overlay_layer: CanvasLayer = null
var current_screen: String = ""
var return_to_pause_after_child: bool = false
var inventory_filter: String = "all"
var inventory_selected_id: String = ""
var save_mode: String = "save"
var save_feedback: String = ""
var options_tab: String = "general"

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	process_priority = 220
	set_process(true)
	set_process_input(true)

func _input(event: InputEvent) -> void:
	var key_event: InputEventKey = event as InputEventKey
	if key_event == null or not key_event.pressed or key_event.echo:
		return
	if key_event.keycode != KEY_ESCAPE:
		return
	if overlay_layer != null:
		if current_screen == "pause":
			close_all()
		else:
			open_pause()
		get_viewport().set_input_as_handled()
		return
	if GameState.run_active:
		open_pause()
		get_viewport().set_input_as_handled()

func _process(_delta: float) -> void:
	var main: Control = _get_main()
	if main == null:
		return
	_sync_hud_proxy(main)
	_sync_main_menu_proxy(main)

	if overlay_layer == null and UIPolish.pause_layer != null:
		if UIPolish.has_method("_close_pause"):
			UIPolish.call("_close_pause")
		open_pause()
	if overlay_layer == null and AchievementsUI.overlay_layer != null:
		if AchievementsUI.has_method("_close_overlay_only"):
			AchievementsUI.call("_close_overlay_only")
		open_trophies(false)

func is_open() -> bool:
	return overlay_layer != null

func open_pause() -> void:
	if not GameState.run_active:
		return
	_close_overlay_only()
	current_screen = "pause"
	return_to_pause_after_child = false
	var root: Control = _create_screen("pause")
	if root == null:
		return

	_add_hotspot_button(root, Rect2(45.0, 212.0, 271.0, 50.0), "Continuar", close_all)
	_add_hotspot_button(root, Rect2(45.0, 268.0, 271.0, 49.0), "Inventário", open_inventory.bind(true))
	_add_hotspot_button(root, Rect2(45.0, 324.0, 271.0, 49.0), "Troféus", open_trophies.bind(true))
	_add_hotspot_button(root, Rect2(45.0, 380.0, 271.0, 49.0), "Save / Load", open_save_load.bind(true))
	_add_hotspot_button(root, Rect2(45.0, 436.0, 271.0, 49.0), "Opções", open_options.bind(true))
	_add_hotspot_button(root, Rect2(45.0, 493.0, 271.0, 49.0), "Voltar ao Menu", _go_main_menu)

	var quit_button: Button = _text_button("Sair do jogo", Color("d94334"))
	quit_button.position = Vector2(331.0, 548.0)
	quit_button.size = Vector2(132.0, 38.0)
	quit_button.add_theme_font_size_override("font_size", 15)
	quit_button.pressed.connect(_quit_game)
	root.add_child(quit_button)

func open_inventory(from_pause: bool = false) -> void:
	_close_overlay_only()
	current_screen = "inventory"
	return_to_pause_after_child = from_pause
	if inventory_selected_id.is_empty() and not GameState.inventory.is_empty():
		inventory_selected_id = str(GameState.inventory[0])
	var root: Control = _create_screen("inventory")
	if root == null:
		return

	_add_close_button(root, Rect2(429.0, 20.0, 48.0, 52.0), _close_child)
	var tabs: Array[Array] = [
		["all", Rect2(25.0, 122.0, 102.0, 40.0)],
		["documents", Rect2(129.0, 122.0, 111.0, 40.0)],
		["items", Rect2(243.0, 122.0, 98.0, 40.0)],
		["equipment", Rect2(344.0, 122.0, 118.0, 40.0)]
	]
	for entry: Array in tabs:
		var tab_id: String = str(entry[0])
		var tab_rect: Rect2 = entry[1]
		var tab_button: Button = _add_hotspot_button(root, tab_rect, tab_id, _set_inventory_filter.bind(tab_id))
		if tab_id == inventory_filter:
			_apply_selected_overlay(tab_button)

	var filtered: Array[String] = _filtered_inventory()
	for index: int in range(mini(filtered.size(), 15)):
		var item_id: String = filtered[index]
		var col: int = index % 5
		var row: int = floori(float(index) / 5.0)
		var slot_rect: Rect2 = Rect2(27.0 + float(col) * 88.0, 170.0 + float(row) * 87.0, 79.0, 79.0)
		var item_button: Button = _icon_button(UIAssets.item_texture(item_id), _item_short_name(item_id))
		item_button.position = slot_rect.position
		item_button.size = slot_rect.size
		item_button.tooltip_text = _item_name(item_id)
		item_button.pressed.connect(_inventory_preview.bind(item_id))
		if item_id == inventory_selected_id:
			_apply_selected_overlay(item_button)
		root.add_child(item_button)

	_build_inventory_description(root)
	_add_brand(root, Vector2(280.0, 556.0), 12)

func open_trophies(from_pause: bool = false) -> void:
	_close_overlay_only()
	current_screen = "trophies"
	return_to_pause_after_child = from_pause
	var root: Control = _create_screen("trophies")
	if root == null:
		return
	_add_close_button(root, Rect2(349.0, 13.0, 54.0, 55.0), _close_child)

	var total: int = AchievementManager.CATALOG.size()
	var unlocked: int = AchievementManager.unlocked_names.size()
	var progress_panel: Panel = _plain_panel(Color(0.96, 0.88, 0.72, 0.96))
	progress_panel.position = Vector2(28.0, 109.0)
	progress_panel.size = Vector2(363.0, 38.0)
	root.add_child(progress_panel)
	var bar: ProgressBar = ProgressBar.new()
	bar.position = Vector2(7.0, 7.0)
	bar.size = Vector2(280.0, 24.0)
	bar.min_value = 0.0
	bar.max_value = float(maxi(total, 1))
	bar.value = float(unlocked)
	bar.show_percentage = false
	progress_panel.add_child(bar)
	var count: Label = Label.new()
	count.position = Vector2(290.0, 3.0)
	count.size = Vector2(68.0, 30.0)
	count.text = "%d / %d" % [unlocked, total]
	count.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	count.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	count.add_theme_font_size_override("font_size", 16)
	count.add_theme_color_override("font_color", Color("332718"))
	progress_panel.add_child(count)

	var list_bg: Panel = _plain_panel(Color(0.95, 0.87, 0.72, 0.97))
	list_bg.position = Vector2(25.0, 151.0)
	list_bg.size = Vector2(369.0, 373.0)
	root.add_child(list_bg)
	var scroll: ScrollContainer = ScrollContainer.new()
	scroll.position = Vector2(8.0, 8.0)
	scroll.size = Vector2(353.0, 357.0)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	list_bg.add_child(scroll)
	var list: VBoxContainer = VBoxContainer.new()
	list.custom_minimum_size = Vector2(335.0, 0.0)
	list.add_theme_constant_override("separation", 6)
	scroll.add_child(list)
	for index: int in range(total):
		var achievement_name: String = str(AchievementManager.CATALOG[index])
		list.add_child(_trophy_row(index + 1, achievement_name, AchievementManager.is_unlocked(achievement_name)))
	_add_brand(root, Vector2(270.0, 541.0), 11)

func open_save_load(from_pause: bool = false) -> void:
	_close_overlay_only()
	current_screen = "save_load"
	return_to_pause_after_child = from_pause
	var root: Control = _create_screen("save_load")
	if root == null:
		return
	_add_close_button(root, Rect2(566.0, 18.0, 52.0, 54.0), _close_child)

	var save_tab: Button = _add_hotspot_button(root, Rect2(32.0, 84.0, 159.0, 41.0), "Salvar", _set_save_mode.bind("save"))
	var load_tab: Button = _add_hotspot_button(root, Rect2(193.0, 84.0, 166.0, 41.0), "Carregar", _set_save_mode.bind("load"))
	if save_mode == "save":
		_apply_selected_overlay(save_tab)
	else:
		_apply_selected_overlay(load_tab)

	for slot: int in range(1, 5):
		_build_save_row(root, slot)

	if not save_feedback.is_empty():
		var feedback: Label = Label.new()
		feedback.position = Vector2(167.0, 384.0)
		feedback.size = Vector2(360.0, 42.0)
		feedback.text = save_feedback
		feedback.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		feedback.add_theme_font_size_override("font_size", 14)
		feedback.add_theme_color_override("font_color", Color("4a3824"))
		root.add_child(feedback)
	_add_brand(root, Vector2(430.0, 421.0), 11)

func open_options(from_pause: bool = false) -> void:
	_close_overlay_only()
	current_screen = "options"
	return_to_pause_after_child = from_pause
	var root: Control = _create_screen("options")
	if root == null:
		return
	_add_close_button(root, Rect2(566.0, 19.0, 52.0, 54.0), _close_child)

	var tabs: Array[Array] = [
		["general", "Geral", Rect2(27.0, 96.0, 155.0, 43.0)],
		["audio", "Áudio", Rect2(27.0, 142.0, 155.0, 42.0)],
		["controls", "Controles", Rect2(27.0, 187.0, 155.0, 42.0)],
		["video", "Vídeo", Rect2(27.0, 232.0, 155.0, 42.0)],
		["accessibility", "Acessibilidade", Rect2(27.0, 277.0, 155.0, 42.0)]
	]
	for entry: Array in tabs:
		var tab_id: String = str(entry[0])
		var tab_label: String = str(entry[1])
		var tab_rect: Rect2 = entry[2]
		var tab_button: Button = _add_hotspot_button(root, tab_rect, tab_label, _set_options_tab.bind(tab_id))
		if options_tab == tab_id:
			_apply_selected_overlay(tab_button)

	var content: Panel = _plain_panel(Color(0.97, 0.90, 0.77, 0.96))
	content.position = Vector2(192.0, 86.0)
	content.size = Vector2(392.0, 257.0)
	root.add_child(content)
	_build_options_content(content)

	var reset: Button = _text_button("Restaurar padrões", Color("a8b0bb"))
	reset.position = Vector2(36.0, 357.0)
	reset.size = Vector2(236.0, 52.0)
	reset.add_theme_font_size_override("font_size", 18)
	reset.pressed.connect(_restore_defaults)
	root.add_child(reset)
	var apply: Button = _text_button("Aplicar", Color("52c93f"))
	apply.position = Vector2(299.0, 357.0)
	apply.size = Vector2(260.0, 52.0)
	apply.add_theme_font_size_override("font_size", 20)
	apply.pressed.connect(_close_child)
	root.add_child(apply)
	_add_brand(root, Vector2(438.0, 420.0), 11)

func close_all() -> void:
	_close_overlay_only()
	current_screen = ""
	return_to_pause_after_child = false

func _close_overlay_only() -> void:
	if overlay_layer != null and is_instance_valid(overlay_layer):
		overlay_layer.queue_free()
	overlay_layer = null

func _close_child() -> void:
	var should_return: bool = return_to_pause_after_child and GameState.run_active
	_close_overlay_only()
	current_screen = ""
	if should_return:
		open_pause()

func _create_screen(screen_name: String) -> Control:
	if not PANEL_REGIONS.has(screen_name):
		return null
	var region: Rect2 = PANEL_REGIONS[screen_name]
	var texture: Texture2D = _atlas_texture(region)
	if texture == null:
		return null

	overlay_layer = CanvasLayer.new()
	overlay_layer.layer = 2000
	add_child(overlay_layer)
	var shade: ColorRect = ColorRect.new()
	shade.color = Color(0.0, 0.0, 0.0, 0.70)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay_layer.add_child(shade)

	var view_size: Vector2 = get_viewport().get_visible_rect().size
	var panel_size: Vector2 = region.size
	var scale_value: float = minf(1.0, minf((view_size.x - 30.0) / panel_size.x, (view_size.y - 30.0) / panel_size.y))
	var root: Control = Control.new()
	root.name = "MenuUIScreen_%s" % screen_name
	root.position = (view_size - panel_size * scale_value) * 0.5
	root.size = panel_size
	root.scale = Vector2(scale_value, scale_value)
	overlay_layer.add_child(root)

	var panel_image: TextureRect = TextureRect.new()
	panel_image.texture = texture
	panel_image.position = Vector2.ZERO
	panel_image.size = panel_size
	panel_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	panel_image.stretch_mode = TextureRect.STRETCH_SCALE
	panel_image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(panel_image)
	return root

func _atlas_texture(region: Rect2) -> Texture2D:
	if not ResourceLoader.exists(PANEL_SHEET_PATH):
		return null
	var resource: Resource = load(PANEL_SHEET_PATH)
	if not (resource is Texture2D):
		return null
	var atlas: AtlasTexture = AtlasTexture.new()
	atlas.atlas = resource as Texture2D
	atlas.region = region
	return atlas

func _add_hotspot_button(root: Control, rect: Rect2, tooltip: String, callback: Callable) -> Button:
	var button: Button = Button.new()
	button.position = rect.position
	button.size = rect.size
	button.text = ""
	button.tooltip_text = tooltip
	button.focus_mode = Control.FOCUS_NONE
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	button.add_theme_stylebox_override("normal", _transparent_style())
	button.add_theme_stylebox_override("hover", _hover_style())
	button.add_theme_stylebox_override("pressed", _selected_style())
	button.pressed.connect(callback)
	root.add_child(button)
	return button

func _add_close_button(root: Control, rect: Rect2, callback: Callable) -> void:
	_add_hotspot_button(root, rect, "Fechar", callback)

func _transparent_style() -> StyleBoxFlat:
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = Color(1.0, 1.0, 1.0, 0.0)
	style.border_color = Color(1.0, 1.0, 1.0, 0.0)
	style.set_border_width_all(0)
	return style

func _hover_style() -> StyleBoxFlat:
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = Color(1.0, 0.82, 0.20, 0.14)
	style.border_color = Color(1.0, 0.72, 0.05, 0.88)
	style.set_border_width_all(3)
	style.corner_radius_top_left = 10
	style.corner_radius_top_right = 10
	style.corner_radius_bottom_left = 10
	style.corner_radius_bottom_right = 10
	return style

func _selected_style() -> StyleBoxFlat:
	var style: StyleBoxFlat = _hover_style()
	style.bg_color = Color(1.0, 0.78, 0.08, 0.24)
	return style

func _apply_selected_overlay(button: Button) -> void:
	button.add_theme_stylebox_override("normal", _selected_style())

func _text_button(text_value: String, base_color: Color) -> Button:
	var button: Button = Button.new()
	button.text = text_value
	button.focus_mode = Control.FOCUS_NONE
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	button.add_theme_color_override("font_color", Color("17120d"))
	button.add_theme_color_override("font_hover_color", Color("17120d"))
	var normal: StyleBoxFlat = StyleBoxFlat.new()
	normal.bg_color = base_color
	normal.border_color = Color("2b2118")
	normal.set_border_width_all(3)
	normal.corner_radius_top_left = 10
	normal.corner_radius_top_right = 10
	normal.corner_radius_bottom_left = 10
	normal.corner_radius_bottom_right = 10
	button.add_theme_stylebox_override("normal", normal)
	var hover: StyleBoxFlat = normal.duplicate() as StyleBoxFlat
	hover.bg_color = base_color.lightened(0.12)
	button.add_theme_stylebox_override("hover", hover)
	button.add_theme_stylebox_override("pressed", hover)
	return button

func _paper_style_box(color_value: Color) -> StyleBoxFlat:
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = color_value
	style.border_color = Color(0.27, 0.20, 0.13, 0.72)
	style.set_border_width_all(2)
	style.corner_radius_top_left = 10
	style.corner_radius_top_right = 10
	style.corner_radius_bottom_left = 10
	style.corner_radius_bottom_right = 10
	return style

func _plain_panel(color_value: Color) -> Panel:
	var panel: Panel = Panel.new()
	panel.add_theme_stylebox_override("panel", _paper_style_box(color_value))
	return panel

func _icon_button(texture: Texture2D, fallback: String) -> Button:
	var button: Button = Button.new()
	button.text = "" if texture != null else fallback
	button.icon = texture
	button.icon_max_width = 58
	button.expand_icon = true
	button.focus_mode = Control.FOCUS_NONE
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	button.add_theme_stylebox_override("normal", _transparent_style())
	button.add_theme_stylebox_override("hover", _hover_style())
	button.add_theme_stylebox_override("pressed", _selected_style())
	button.add_theme_font_size_override("font_size", 11)
	button.add_theme_color_override("font_color", Color("2f2418"))
	return button

func _add_brand(root: Control, position_value: Vector2, font_size: int) -> void:
	var label: Label = Label.new()
	label.position = position_value
	label.size = Vector2(180.0, 22.0)
	label.text = "PROTOCOLO: PIZZA"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", Color(0.26, 0.20, 0.14, 0.72))
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(label)

func _set_inventory_filter(filter_id: String) -> void:
	inventory_filter = filter_id
	if not _inventory_matches(inventory_selected_id, filter_id):
		inventory_selected_id = ""
	open_inventory(return_to_pause_after_child)

func _filtered_inventory() -> Array[String]:
	var result: Array[String] = []
	for value: Variant in GameState.inventory:
		var item_id: String = str(value)
		if _inventory_matches(item_id, inventory_filter):
			result.append(item_id)
	return result

func _inventory_matches(item_id: String, filter_id: String) -> bool:
	if item_id.is_empty():
		return false
	if filter_id == "all":
		return true
	var documents: Array[String] = ["visitor_badge", "third_party_proof", "fiscal_exception_protocol", "work_order", "third_party_form", "rh_validation_signature", "legal_bolota_pending", "legal_bolota_approved"]
	var equipment: Array[String] = ["vr_glasses", "maintenance_vest"]
	if filter_id == "documents":
		return item_id in documents
	if filter_id == "equipment":
		return item_id in equipment
	if filter_id == "items":
		return not (item_id in documents) and not (item_id in equipment)
	return true

func _inventory_preview(item_id: String) -> void:
	inventory_selected_id = item_id
	open_inventory(return_to_pause_after_child)

func _build_inventory_description(root: Control) -> void:
	if inventory_selected_id.is_empty():
		return
	var icon: Texture2D = UIAssets.item_texture(inventory_selected_id)
	if icon != null:
		var preview: TextureRect = TextureRect.new()
		preview.texture = icon
		preview.position = Vector2(45.0, 450.0)
		preview.size = Vector2(78.0, 78.0)
		preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		preview.mouse_filter = Control.MOUSE_FILTER_IGNORE
		root.add_child(preview)
	var title: Label = Label.new()
	title.position = Vector2(142.0, 446.0)
	title.size = Vector2(300.0, 28.0)
	title.text = _item_name(inventory_selected_id)
	title.add_theme_font_size_override("font_size", 18)
	title.add_theme_color_override("font_color", Color("2d2116"))
	root.add_child(title)
	var description: Label = Label.new()
	description.position = Vector2(142.0, 474.0)
	description.size = Vector2(300.0, 48.0)
	description.text = _item_description(inventory_selected_id)
	description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	description.add_theme_font_size_override("font_size", 13)
	description.add_theme_color_override("font_color", Color("4c3926"))
	root.add_child(description)
	var action_text: String = "Vestir" if inventory_selected_id == "maintenance_vest" else "Selecionar"
	var action: Button = _text_button(action_text, Color("f7c934"))
	action.position = Vector2(334.0, 523.0)
	action.size = Vector2(112.0, 34.0)
	action.add_theme_font_size_override("font_size", 14)
	action.pressed.connect(_inventory_use_selected)
	root.add_child(action)

func _inventory_use_selected() -> void:
	if inventory_selected_id.is_empty():
		return
	var main: Control = _get_main()
	if inventory_selected_id == "maintenance_vest":
		GameFlow.equip_item(inventory_selected_id)
		if main != null:
			main.set("selected_item", "")
			main.set("feedback_text", "Colete de Manutenção vestido. Selecione a Ordem de Serviço para apresentar à Vigilância.")
	else:
		if main != null:
			main.set("selected_item", inventory_selected_id)
			main.set("feedback_text", "Selecionado: %s. Agora clique no alvo do cenário." % _item_name(inventory_selected_id))
	close_all()

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

func _item_short_name(item_id: String) -> String:
	var short_names: Dictionary = {
		"visitor_badge": "Crachá",
		"vr_glasses": "VR",
		"executive_priority_stamp": "Carimbo",
		"third_party_proof": "Terceiro",
		"fiscal_exception_protocol": "Fiscal",
		"maintenance_vest": "Colete",
		"work_order": "OS",
		"third_party_form": "Ficha",
		"rh_validation_signature": "Ass. RH",
		"legal_bolota_pending": "Bolota",
		"legal_bolota_approved": "Bolota"
	}
	return str(short_names.get(item_id, item_id))

func _item_description(item_id: String) -> String:
	var descriptions: Dictionary = {
		"visitor_badge": "Identificação liberada pela Recepção.",
		"vr_glasses": "Equipamento de Inovação. Rogério Wilco pode gostar disso.",
		"executive_priority_stamp": "Carimbo que transforma urgência em prioridade corporativa.",
		"third_party_proof": "Comprova seu vínculo temporário com o processo.",
		"fiscal_exception_protocol": "Exceção fiscal aprovada. Milagre documentado.",
		"maintenance_vest": "Disfarce funcional para circular como manutenção.",
		"work_order": "OS necessária para justificar a passagem pela Vigilância.",
		"third_party_form": "Formulário usado no fluxo de cadastro do RH.",
		"rh_validation_signature": "Assinatura que encerra a validação do RH.",
		"legal_bolota_pending": "Carimbo jurídico ainda pendente de aprovação.",
		"legal_bolota_approved": "Bolota jurídica aprovada e pronta para fechar o processo."
	}
	return str(descriptions.get(item_id, "Item coletado durante o processo."))

func _trophy_row(number: int, achievement_name: String, unlocked: bool) -> Control:
	var row: PanelContainer = PanelContainer.new()
	var row_color: Color = Color(0.99, 0.94, 0.84, 0.98) if unlocked else Color(0.82, 0.77, 0.67, 0.98)
	row.add_theme_stylebox_override("panel", _paper_style_box(row_color))
	row.custom_minimum_size = Vector2(332.0, 54.0)
	var line: HBoxContainer = HBoxContainer.new()
	line.add_theme_constant_override("separation", 8)
	row.add_child(line)
	if unlocked:
		var texture: Texture2D = UIAssets.load_texture(UIAssets.TROPHY_ICON)
		if texture != null:
			var icon: TextureRect = TextureRect.new()
			icon.texture = texture
			icon.custom_minimum_size = Vector2(34.0, 34.0)
			icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			line.add_child(icon)
	else:
		var lock: Label = Label.new()
		lock.text = "🔒"
		lock.custom_minimum_size = Vector2(34.0, 34.0)
		lock.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lock.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		line.add_child(lock)
	var label: Label = Label.new()
	label.text = "%02d. %s" % [number, achievement_name]
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 14)
	label.add_theme_color_override("font_color", Color("2e2419") if unlocked else Color("5f594f"))
	line.add_child(label)
	return row

func _set_save_mode(mode_id: String) -> void:
	save_mode = mode_id
	save_feedback = ""
	open_save_load(return_to_pause_after_child)

func _build_save_row(root: Control, slot: int) -> void:
	var y: float = 134.0 + float(slot - 1) * 58.0
	var meta: Dictionary = SaveManager.get_slot_metadata(slot)
	var row: Button = _text_button("", Color(0.97, 0.91, 0.80, 0.96))
	row.position = Vector2(34.0, y)
	row.size = Vector2(522.0, 50.0)
	row.alignment = HORIZONTAL_ALIGNMENT_LEFT
	row.tooltip_text = "Slot %d" % slot
	var action_enabled: bool = GameState.run_active if save_mode == "save" else not meta.is_empty()
	row.disabled = not action_enabled
	row.pressed.connect(_activate_save_slot.bind(slot))
	root.add_child(row)

	var info: Label = Label.new()
	info.position = Vector2(82.0, y + 5.0)
	info.size = Vector2(430.0, 42.0)
	if meta.is_empty():
		info.text = "Slot %d — vazio" % slot
	else:
		var area: String = str(meta.get("area", "?"))
		var minutes: int = int(meta.get("minutes", 0))
		var saved_at: String = str(meta.get("saved_at", ""))
		info.text = "Slot %d  •  %s  •  %d min\n%s" % [slot, area, minutes, saved_at]
	info.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	info.add_theme_font_size_override("font_size", 14)
	info.add_theme_color_override("font_color", Color("3e3021"))
	info.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(info)

	var delete: Button = Button.new()
	delete.text = "🗑"
	delete.position = Vector2(558.0, y + 5.0)
	delete.size = Vector2(38.0, 40.0)
	delete.disabled = meta.is_empty()
	delete.focus_mode = Control.FOCUS_NONE
	delete.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	delete.pressed.connect(_delete_save_slot.bind(slot))
	root.add_child(delete)

func _activate_save_slot(slot: int) -> void:
	if save_mode == "save":
		if SaveManager.save_slot(slot):
			save_feedback = "Partida salva no Slot %d." % slot
		else:
			save_feedback = "Não foi possível salvar neste momento."
		open_save_load(return_to_pause_after_child)
		return
	if SaveManager.load_slot(slot):
		save_feedback = "Partida carregada."
		var main: Control = _get_main()
		close_all()
		if main != null:
			main.set("selected_item", "")
			main.set("feedback_text", "Partida carregada.")
			if main.has_method("show_game"):
				main.call("show_game")

func _delete_save_slot(slot: int) -> void:
	SaveManager.delete_slot(slot)
	save_feedback = "Slot %d apagado." % slot
	open_save_load(return_to_pause_after_child)

func _set_options_tab(tab_id: String) -> void:
	options_tab = tab_id
	open_options(return_to_pause_after_child)

func _build_options_content(panel: Panel) -> void:
	var box: VBoxContainer = VBoxContainer.new()
	box.position = Vector2(18.0, 14.0)
	box.size = Vector2(356.0, 228.0)
	box.add_theme_constant_override("separation", 8)
	panel.add_child(box)
	match options_tab:
		"general":
			box.add_child(_option_slider_row("Volume geral", "master_volume"))
			box.add_child(_option_slider_row("Música", "music_volume"))
			box.add_child(_option_toggle_row("Tela cheia", "fullscreen"))
		"audio":
			box.add_child(_option_slider_row("Volume geral", "master_volume"))
			box.add_child(_option_slider_row("Música", "music_volume"))
			box.add_child(_option_slider_row("Efeitos sonoros", "sfx_volume"))
		"controls":
			box.add_child(_info_label("Mouse: mover e interagir\nA/B/C/D: escolhas de diálogo\nESC: menu\nF1: HUD  •  F2: Hotspots  •  F3: Coordenadas"))
		"video":
			box.add_child(_option_toggle_row("Tela cheia", "fullscreen"))
			box.add_child(_info_label("Resolução base: 1280 × 720\nProporção preservada para os cenários."))
		"accessibility":
			box.add_child(_info_label("Cursor muda em áreas clicáveis.\nTextos de diálogo usam balões de alta leitura.\nMais opções de acessibilidade entrarão após o piloto de UI."))

func _option_slider_row(label_text: String, key: String) -> Control:
	var row: HBoxContainer = HBoxContainer.new()
	row.custom_minimum_size = Vector2(350.0, 48.0)
	var label: Label = Label.new()
	label.text = label_text
	label.custom_minimum_size = Vector2(132.0, 42.0)
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 15)
	label.add_theme_color_override("font_color", Color("3b2d20"))
	row.add_child(label)
	var slider: HSlider = HSlider.new()
	slider.min_value = 0.0
	slider.max_value = 1.0
	slider.step = 0.05
	slider.value = float(SettingsManager.get_value(key, 0.8))
	slider.custom_minimum_size = Vector2(170.0, 42.0)
	slider.value_changed.connect(_option_slider_changed.bind(key))
	row.add_child(slider)
	var percent: Label = Label.new()
	percent.text = "%d%%" % int(round(slider.value * 100.0))
	percent.custom_minimum_size = Vector2(46.0, 42.0)
	percent.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	percent.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	percent.add_theme_font_size_override("font_size", 14)
	row.add_child(percent)
	return row

func _option_toggle_row(label_text: String, key: String) -> Control:
	var row: HBoxContainer = HBoxContainer.new()
	row.custom_minimum_size = Vector2(350.0, 50.0)
	var label: Label = Label.new()
	label.text = label_text
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 15)
	label.add_theme_color_override("font_color", Color("3b2d20"))
	row.add_child(label)
	var toggle: CheckButton = CheckButton.new()
	toggle.button_pressed = bool(SettingsManager.get_value(key, false))
	toggle.toggled.connect(_option_toggle_changed.bind(key))
	row.add_child(toggle)
	return row

func _info_label(text_value: String) -> Label:
	var label: Label = Label.new()
	label.text = text_value
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.custom_minimum_size = Vector2(350.0, 180.0)
	label.add_theme_font_size_override("font_size", 15)
	label.add_theme_color_override("font_color", Color("3b2d20"))
	return label

func _option_slider_changed(value: float, key: String) -> void:
	SettingsManager.set_value(key, value)

func _option_toggle_changed(pressed: bool, key: String) -> void:
	SettingsManager.set_value(key, pressed)

func _restore_defaults() -> void:
	SettingsManager.set_value("master_volume", 0.85)
	SettingsManager.set_value("music_volume", 0.75)
	SettingsManager.set_value("sfx_volume", 0.85)
	SettingsManager.set_value("fullscreen", false)
	open_options(return_to_pause_after_child)

func _get_main() -> Control:
	var current: Node = get_tree().current_scene
	if current is Control:
		return current as Control
	return null

func _sync_hud_proxy(main: Control) -> void:
	if not GameState.run_active:
		return
	_sync_proxy_for_named_button(main, "HUDMenuButton", "MenuUI_HUDMenuProxy", open_pause)
	_sync_proxy_for_named_button(main, "HUDTrophyButton", "MenuUI_HUDTrophyProxy", open_trophies.bind(false))

func _sync_proxy_for_named_button(main: Control, source_name: String, proxy_name: String, callback: Callable) -> void:
	var source: Button = main.find_child(source_name, false, false) as Button
	if source == null:
		return
	source.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var proxy: Button = main.get_node_or_null(proxy_name) as Button
	if proxy == null:
		proxy = Button.new()
		proxy.name = proxy_name
		proxy.text = ""
		proxy.focus_mode = Control.FOCUS_NONE
		proxy.z_index = 950
		proxy.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		proxy.add_theme_stylebox_override("normal", _transparent_style())
		proxy.add_theme_stylebox_override("hover", _hover_style())
		proxy.pressed.connect(callback)
		main.add_child(proxy)
	proxy.position = source.position
	proxy.size = source.size
	proxy.visible = source.visible

func _sync_main_menu_proxy(main: Control) -> void:
	if GameState.run_active:
		return
	_sync_menu_tooltip_proxy(main, "Save / Load", "MenuUI_MainSaveProxy", open_save_load.bind(false))
	_sync_menu_tooltip_proxy(main, "Opções", "MenuUI_MainOptionsProxy", open_options.bind(false))

func _sync_menu_tooltip_proxy(main: Control, tooltip: String, proxy_name: String, callback: Callable) -> void:
	var source: Button = null
	for child: Node in main.get_children():
		if child is Button:
			var candidate: Button = child as Button
			if candidate.tooltip_text == tooltip and not str(candidate.name).begins_with("MenuUI_"):
				source = candidate
				break
	if source == null:
		return
	source.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var proxy: Button = main.get_node_or_null(proxy_name) as Button
	if proxy == null:
		proxy = Button.new()
		proxy.name = proxy_name
		proxy.text = ""
		proxy.tooltip_text = tooltip
		proxy.focus_mode = Control.FOCUS_NONE
		proxy.z_index = 950
		proxy.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		proxy.add_theme_stylebox_override("normal", _transparent_style())
		proxy.add_theme_stylebox_override("hover", _hover_style())
		proxy.pressed.connect(callback)
		main.add_child(proxy)
	proxy.position = source.position
	proxy.size = source.size
	proxy.visible = source.visible

func _go_main_menu() -> void:
	close_all()
	if DialogueUI.is_open():
		DialogueUI.close_dialogue()
	DialogueUI.close_speech()
	GameState.reset_run(false)
	var main: Control = _get_main()
	if main != null and main.has_method("show_menu"):
		main.call("show_menu")

func _quit_game() -> void:
	close_all()
	if DialogueUI.is_open():
		DialogueUI.close_dialogue()
	DialogueUI.close_speech()
	GameState.run_active = false
	get_tree().quit()
