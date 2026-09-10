extends Control

const HotspotCatalog = preload("res://scripts/hotspot_catalog.gd")
const UIAssets = preload("res://scripts/ui_asset_catalog.gd")

var selected_item := ""
var feedback_text := "Clique nos elementos do cenário. Itens do inventário podem ser selecionados e usados nos hotspots."
var image_origin := Vector2.ZERO
var image_scale := 1.0
var current_source_size := Vector2(1672, 941)
var modal_layer: Control

func _ready() -> void:
	SceneRouter.area_changed.connect(_on_area_changed)
	GameFlow.feedback.connect(_on_feedback)
	GameFlow.finished.connect(_on_finished)
	AchievementManager.achievement_unlocked.connect(_on_achievement)
	show_menu()

func _clear() -> void:
	for child in get_children():
		child.free()
	modal_layer = null

func _fit_image(area_id: String) -> void:
	var path := HotspotCatalog.get_background(area_id)
	var texture = load(path)
	if texture == null:
		return
	current_source_size = HotspotCatalog.get_source_size(area_id)
	var view := get_viewport_rect().size
	image_scale = minf(view.x / current_source_size.x, view.y / current_source_size.y)
	var display := current_source_size * image_scale
	image_origin = (view - display) * 0.5
	var bg := TextureRect.new()
	bg.texture = texture
	bg.position = image_origin
	bg.size = display
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.stretch_mode = TextureRect.STRETCH_SCALE
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)

func _hotspot(rect_data: Array, label: String, callback: Callable) -> Button:
	var b := Button.new()
	b.text = ""
	b.tooltip_text = label
	b.focus_mode = Control.FOCUS_NONE
	b.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	var x := float(rect_data[0])
	var y := float(rect_data[1])
	var w := float(rect_data[2])
	var h := float(rect_data[3])
	b.position = image_origin + Vector2(x, y) * image_scale
	b.size = Vector2(w, h) * image_scale
	var normal := StyleBoxFlat.new()
	normal.bg_color = Color(1, 1, 1, 0.0)
	normal.border_color = Color(1, 1, 1, 0.0)
	normal.set_border_width_all(2)
	b.add_theme_stylebox_override("normal", normal)
	var hover := StyleBoxFlat.new()
	hover.bg_color = Color(1.0, 0.82, 0.2, 0.08)
	hover.border_color = Color(1.0, 0.82, 0.2, 0.95)
	hover.set_border_width_all(3)
	hover.corner_radius_top_left = 12
	hover.corner_radius_top_right = 12
	hover.corner_radius_bottom_left = 12
	hover.corner_radius_bottom_right = 12
	b.add_theme_stylebox_override("hover", hover)
	b.add_theme_stylebox_override("pressed", hover)
	b.pressed.connect(callback)
	add_child(b)
	return b

func _dark_panel() -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = Color(0.03, 0.06, 0.09, 0.88)
	s.border_color = Color(1.0, 0.78, 0.18, 0.65)
	s.set_border_width_all(2)
	s.corner_radius_top_left = 14
	s.corner_radius_top_right = 14
	s.corner_radius_bottom_left = 14
	s.corner_radius_bottom_right = 14
	return s

func show_menu() -> void:
	_clear()
	selected_item = ""
	_fit_image("menu")
	_hotspot([900,315,390,120], "Novo Jogo", _new_game)
	_hotspot([900,445,390,120], "Save / Load", _open_save_load)
	_hotspot([900,570,390,120], "Opções", _open_options)

func _new_game() -> void:
	GameState.reset_run(true)
	feedback_text = "Bem-vindo à PAPO SAPÃO. A missão é simples: entregar a pizza para Ronaldo Gilberto."
	SceneRouter.route_to("reception")

func show_game() -> void:
	_clear()
	var area := GameState.current_area
	_fit_image(area)
	for hs in HotspotCatalog.get_hotspots(area):
		var data := Dictionary(hs)
		_hotspot(Array(data["rect"]), str(data["label"]), _activate_hotspot.bind(str(data["action"])))
	_build_hud()
	if area == "directorate" and GameState.has_flag("director_question"):
		_build_director_choices()

func _activate_hotspot(action_id: String) -> void:
	var area_before := GameState.current_area
	GameFlow.perform(action_id, selected_item)
	if action_id in ["rogerio","supplies_stan","security_sonia","legal_analysis"]:
		selected_item = ""
	if GameState.run_active and GameState.current_area == area_before:
		show_game()

func _build_hud() -> void:
	var top := PanelContainer.new()
	top.name = "HUDTopPanel"
	top.position = Vector2(12, 10)
	top.size = Vector2(690, 58)
	top.add_theme_stylebox_override("panel", _dark_panel())
	add_child(top)
	var top_row := HBoxContainer.new()
	top_row.add_theme_constant_override("separation", 10)
	top.add_child(top_row)
	var area_label := Label.new()
	area_label.text = HotspotCatalog.get_title(GameState.current_area)
	area_label.add_theme_font_size_override("font_size", 22)
	area_label.add_theme_color_override("font_color", Color("ffd34e"))
	area_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top_row.add_child(area_label)

	var pizza_icon: Texture2D = UIAssets.load_texture(UIAssets.PIZZA_ICON)
	if pizza_icon != null:
		var pizza_texture := TextureRect.new()
		pizza_texture.texture = pizza_icon
		pizza_texture.custom_minimum_size = Vector2(42, 42)
		pizza_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		pizza_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		pizza_texture.mouse_filter = Control.MOUSE_FILTER_IGNORE
		top_row.add_child(pizza_texture)
	var pizza := Label.new()
	pizza.text = "%s%%  |  %s min" % [str(GameState.pizza.get("temperature", 100)), str(GameState.pizza.get("elapsed_minutes", 0))]
	pizza.add_theme_font_size_override("font_size", 17)
	pizza.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	top_row.add_child(pizza)

	var view_width: float = get_viewport_rect().size.x
	var trophy := _hud_icon_button(UIAssets.TROPHY_ICON, "🏆", "HUDTrophyButton", AchievementsUI.open.bind(false))
	trophy.position = Vector2(view_width - 120, 10)
	add_child(trophy)
	var pause := _hud_icon_button(UIAssets.MENU_ICON, "☰", "HUDMenuButton", _open_pause)
	pause.position = Vector2(view_width - 62, 10)
	add_child(pause)

	if not _uses_balloon_hud():
		var dialogue := PanelContainer.new()
		dialogue.name = "HUDBottomDialogue"
		dialogue.position = Vector2(170, get_viewport_rect().size.y - 126)
		dialogue.size = Vector2(get_viewport_rect().size.x - 340, 106)
		dialogue.add_theme_stylebox_override("panel", _dark_panel())
		add_child(dialogue)
		var d := Label.new()
		d.text = feedback_text
		d.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		d.add_theme_font_size_override("font_size", 18)
		d.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		d.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		dialogue.add_child(d)

	var inv := PanelContainer.new()
	inv.position = Vector2(12, get_viewport_rect().size.y - 126)
	inv.size = Vector2(150, 106)
	inv.add_theme_stylebox_override("panel", _dark_panel())
	add_child(inv)
	var inv_box := VBoxContainer.new()
	inv_box.add_theme_constant_override("separation", 4)
	inv.add_child(inv_box)
	var t := Label.new()
	t.text = "Inventário"
	t.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	t.add_theme_color_override("font_color", Color("ffd34e"))
	inv_box.add_child(t)
	if GameState.inventory.is_empty():
		var empty := Label.new()
		empty.text = "(vazio)"
		empty.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		inv_box.add_child(empty)
	else:
		for item in GameState.inventory:
			var b := Button.new()
			b.text = _item_name(item)
			var item_texture: Texture2D = UIAssets.item_texture(str(item))
			if item_texture != null:
				b.icon = item_texture
				b.icon_max_width = 26
			b.tooltip_text = "Selecionado: use no cenário. Colete: clique novamente para vestir."
			b.add_theme_font_size_override("font_size", 12)
			if selected_item == item:
				b.modulate = Color("ffd34e")
			b.pressed.connect(_select_item.bind(item))
			inv_box.add_child(b)

func _hud_icon_button(icon_path: String, fallback_text: String, node_name: String, callback: Callable) -> Button:
	var button := Button.new()
	button.name = node_name
	button.size = Vector2(50, 50)
	button.focus_mode = Control.FOCUS_NONE
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	var texture: Texture2D = UIAssets.load_texture(icon_path)
	if texture != null:
		button.icon = texture
		button.icon_max_width = 42
		button.text = ""
	else:
		button.text = fallback_text
		button.add_theme_font_size_override("font_size", 24)
	button.pressed.connect(callback)
	return button

func _uses_balloon_hud() -> bool:
	return GameState.current_area == "reception"

func _select_item(item_id: String) -> void:
	if selected_item == item_id and item_id == "maintenance_vest":
		GameFlow.equip_item(item_id)
		selected_item = ""
	else:
		selected_item = item_id
		feedback_text = "Selecionado: %s. Agora clique no alvo do cenário." % _item_name(item_id)
	show_game()

func _item_name(item_id: String) -> String:
	var names := {
		"visitor_badge":"Crachá",
		"vr_glasses":"Óculos VR",
		"executive_priority_stamp":"Carimbo",
		"third_party_proof":"Comprovante",
		"fiscal_exception_protocol":"Protocolo",
		"maintenance_vest":"Colete",
		"work_order":"OS",
		"third_party_form":"Ficha RH",
		"rh_validation_signature":"Assinatura RH",
		"legal_bolota_pending":"Bolota Pendente",
		"legal_bolota_approved":"Bolota Aprovada"
	}
	return str(names.get(item_id, item_id))

func _build_director_choices() -> void:
	var panel := PanelContainer.new()
	panel.position = Vector2(420, 150)
	panel.size = Vector2(440, 240)
	panel.add_theme_stylebox_override("panel", _dark_panel())
	add_child(panel)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)
	panel.add_child(box)
	var title := Label.new()
	title.text = "Qual o nome do diretor?"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 22)
	box.add_child(title)
	for entry in [["Ronaldo Gilberto", true],["Rogério Wilco", false],["Stan Leilo", false]]:
		var b := Button.new()
		b.text = str(entry[0])
		b.add_theme_font_size_override("font_size", 18)
		b.pressed.connect(_director_choice.bind(bool(entry[1])))
		box.add_child(b)

func _director_choice(correct: bool) -> void:
	GameFlow.perform("director_answer_correct" if correct else "director_answer_wrong")
	if GameState.run_active:
		show_game()

func _open_pause() -> void:
	_show_modal("PAUSA", [
		["Salvar / Carregar", _open_save_load],
		["Opções", _open_options],
		["Voltar ao jogo", _close_modal],
		["Menu principal", show_menu]
	])

func _show_modal(title_text: String, buttons: Array) -> void:
	if modal_layer:
		modal_layer.queue_free()
	modal_layer = ColorRect.new()
	modal_layer.color = Color(0,0,0,0.72)
	modal_layer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(modal_layer)
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	modal_layer.add_child(center)
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(520, 0)
	panel.add_theme_stylebox_override("panel", _dark_panel())
	center.add_child(panel)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 10)
	panel.add_child(box)
	var title := Label.new()
	title.text = title_text
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 30)
	title.add_theme_color_override("font_color", Color("ffd34e"))
	box.add_child(title)
	for entry in buttons:
		var b := Button.new()
		b.text = str(entry[0])
		b.custom_minimum_size = Vector2(420, 50)
		b.add_theme_font_size_override("font_size", 19)
		var callback: Callable = entry[1]
		b.pressed.connect(callback)
		box.add_child(b)

func _close_modal() -> void:
	if modal_layer:
		modal_layer.queue_free()
		modal_layer = null

func _open_save_load() -> void:
	if modal_layer:
		modal_layer.queue_free()
	modal_layer = ColorRect.new()
	modal_layer.color = Color(0,0,0,0.76)
	modal_layer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(modal_layer)
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	modal_layer.add_child(center)
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(760, 0)
	panel.add_theme_stylebox_override("panel", _dark_panel())
	center.add_child(panel)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 10)
	panel.add_child(box)
	var title := Label.new()
	title.text = "SAVE / LOAD"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 30)
	title.add_theme_color_override("font_color", Color("ffd34e"))
	box.add_child(title)
	for slot in range(1,4):
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 8)
		box.add_child(row)
		var meta := SaveManager.get_slot_metadata(slot)
		var info := Label.new()
		info.text = "Slot %d — vazio" % slot if meta.is_empty() else "Slot %d — %s — %s min" % [slot, str(meta.get("area","?")), str(meta.get("minutes",0))]
		info.custom_minimum_size = Vector2(370, 46)
		info.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		row.add_child(info)
		var save := Button.new()
		save.text = "Salvar"
		save.disabled = not GameState.run_active
		save.pressed.connect(_save_slot.bind(slot))
		row.add_child(save)
		var load := Button.new()
		load.text = "Carregar"
		load.disabled = not SaveManager.has_slot(slot)
		load.pressed.connect(_load_slot.bind(slot))
		row.add_child(load)
	var back := Button.new()
	back.text = "Voltar"
	back.pressed.connect(_close_modal)
	box.add_child(back)

func _save_slot(slot: int) -> void:
	if SaveManager.save_slot(slot):
		feedback_text = "Partida salva no Slot %d." % slot
	_open_save_load()

func _load_slot(slot: int) -> void:
	if SaveManager.load_slot(slot):
		selected_item = ""
		feedback_text = "Partida carregada."
		_close_modal()
		show_game()

func _open_options() -> void:
	if modal_layer:
		modal_layer.queue_free()
	modal_layer = ColorRect.new()
	modal_layer.color = Color(0,0,0,0.76)
	modal_layer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(modal_layer)
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	modal_layer.add_child(center)
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(620, 0)
	panel.add_theme_stylebox_override("panel", _dark_panel())
	center.add_child(panel)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 10)
	panel.add_child(box)
	var title := Label.new()
	title.text = "OPÇÕES"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 30)
	title.add_theme_color_override("font_color", Color("ffd34e"))
	box.add_child(title)
	box.add_child(_slider_row("Volume geral", "master_volume"))
	box.add_child(_slider_row("Música", "music_volume"))
	box.add_child(_slider_row("Efeitos", "sfx_volume"))
	var fs := CheckButton.new()
	fs.text = "Tela cheia"
	fs.button_pressed = bool(SettingsManager.get_value("fullscreen", false))
	fs.toggled.connect(func(v): SettingsManager.set_value("fullscreen", v))
	box.add_child(fs)
	var back := Button.new()
	back.text = "Voltar"
	back.pressed.connect(_close_modal)
	box.add_child(back)

func _slider_row(label_text: String, key: String) -> Control:
	var row := HBoxContainer.new()
	var label := Label.new()
	label.text = label_text
	label.custom_minimum_size = Vector2(180, 36)
	row.add_child(label)
	var slider := HSlider.new()
	slider.min_value = 0
	slider.max_value = 1
	slider.step = 0.05
	slider.value = float(SettingsManager.get_value(key, 0.8))
	slider.custom_minimum_size = Vector2(340,36)
	slider.value_changed.connect(func(v): SettingsManager.set_value(key, v))
	row.add_child(slider)
	return row

func _on_area_changed(_area_id: String) -> void:
	show_game()

func _on_feedback(text: String) -> void:
	feedback_text = text
	if GameState.current_area == "reception" and GameState.run_active:
		_show_reception_speech(text)

func _show_reception_speech(text: String) -> void:
	var speaker: String = "PAPO SAPÃO"
	var message: String = text
	var anchor: Vector2 = Vector2(836, 280)
	if text.begins_with("Eliana Marli:"):
		speaker = "Eliana Marli"
		message = text.trim_prefix("Eliana Marli:").strip_edges()
		anchor = Vector2(635, 320)
	elif text.begins_with("Mauro Portela:"):
		speaker = "Mauro Portela"
		message = text.trim_prefix("Mauro Portela:").strip_edges()
		anchor = Vector2(1092, 340)
	elif text.begins_with("Totem"):
		speaker = "Totem de Cadastro"
		message = text.trim_prefix("Totem — ").trim_prefix("Totem:").strip_edges()
		anchor = Vector2(840, 350)
	elif text.begins_with("A segurança"):
		speaker = "Mauro Portela"
		anchor = Vector2(1092, 340)
	DialogueUI.show_speech(speaker, message, anchor)

func _on_finished(ending_name: String, message: String) -> void:
	_clear()
	var bg_area := GameState.current_area if HotspotCatalog.BACKGROUNDS.has(GameState.current_area) else "menu"
	_fit_image(bg_area)
	var shade := ColorRect.new()
	shade.color = Color(0,0,0,0.70)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(shade)
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(760, 0)
	panel.add_theme_stylebox_override("panel", _dark_panel())
	center.add_child(panel)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 16)
	panel.add_child(box)
	var title := Label.new()
	title.text = ending_name
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 42)
	title.add_theme_color_override("font_color", Color("ffd34e"))
	box.add_child(title)
	var body := Label.new()
	body.text = message
	body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	body.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	body.add_theme_font_size_override("font_size", 20)
	box.add_child(body)
	var restart := Button.new()
	restart.text = "Nova partida"
	restart.pressed.connect(_new_game)
	box.add_child(restart)
	var menu := Button.new()
	menu.text = "Menu principal"
	menu.pressed.connect(show_menu)
	box.add_child(menu)

func _on_achievement(name: String) -> void:
	feedback_text = "🏆 Conquista desbloqueada: %s" % name
