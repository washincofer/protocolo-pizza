extends Control

const AreaCatalog = preload("res://scripts/area_catalog.gd")

var current_screen := "menu"
var feedback_text := ""
var title_font_size := 54
var body_font_size := 20

func _ready() -> void:
	SceneRouter.area_changed.connect(_on_area_changed)
	GameFlow.feedback.connect(_on_feedback)
	GameFlow.finished.connect(_on_finished)
	AchievementManager.achievement_unlocked.connect(_on_achievement_unlocked)
	show_menu()

func _clear() -> void:
	for child in get_children():
		child.free()

func _background(path: String) -> void:
	var fallback := ColorRect.new()
	fallback.color = Color("182535")
	fallback.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(fallback)
	var texture = load(path)
	if texture:
		var bg := TextureRect.new()
		bg.texture = texture
		bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		add_child(bg)
	var shade := ColorRect.new()
	shade.color = Color(0.02, 0.05, 0.08, 0.34)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(shade)

func _panel_style(alpha: float = 0.92) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.05, 0.09, 0.14, alpha)
	style.border_color = Color(1.0, 0.78, 0.18, 0.55)
	style.set_border_width_all(2)
	style.corner_radius_top_left = 18
	style.corner_radius_top_right = 18
	style.corner_radius_bottom_left = 18
	style.corner_radius_bottom_right = 18
	style.content_margin_left = 22
	style.content_margin_right = 22
	style.content_margin_top = 18
	style.content_margin_bottom = 18
	return style

func _button(text: String, callback: Callable, accent := false) -> Button:
	var b := Button.new()
	b.text = text
	b.custom_minimum_size = Vector2(360, 58)
	b.add_theme_font_size_override("font_size", 24)
	var normal := StyleBoxFlat.new()
	normal.bg_color = Color("f4b942") if accent else Color("23415d")
	normal.border_color = Color("ffffff44")
	normal.set_border_width_all(2)
	normal.corner_radius_top_left = 12
	normal.corner_radius_top_right = 12
	normal.corner_radius_bottom_left = 12
	normal.corner_radius_bottom_right = 12
	b.add_theme_stylebox_override("normal", normal)
	var hover := normal.duplicate()
	hover.bg_color = normal.bg_color.lightened(0.12)
	b.add_theme_stylebox_override("hover", hover)
	if accent:
		b.add_theme_color_override("font_color", Color("18222f"))
	b.pressed.connect(callback)
	return b

func _label(text: String, size: int = 20, color := Color.WHITE) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", color)
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return l

func show_menu() -> void:
	current_screen = "menu"
	_clear()
	_background("res://assets/scenarios/menu.png")
	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 80)
	margin.add_theme_constant_override("margin_right", 80)
	margin.add_theme_constant_override("margin_top", 70)
	margin.add_theme_constant_override("margin_bottom", 70)
	add_child(margin)
	var outer := VBoxContainer.new()
	outer.alignment = BoxContainer.ALIGNMENT_CENTER
	margin.add_child(outer)
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(520, 0)
	panel.add_theme_stylebox_override("panel", _panel_style(0.87))
	outer.add_child(panel)
	var box := VBoxContainer.new()
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.add_theme_constant_override("separation", 14)
	panel.add_child(box)
	var title := _label("PROTOCOLO: PIZZA", title_font_size, Color("ffd34e"))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(title)
	var subtitle := _label("PAPO SAPÃO\nSua missão é simples. O processo não.", 21, Color("e6edf3"))
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(subtitle)
	box.add_child(_button("▶  Novo Jogo", _start_new_game, true))
	box.add_child(_button("▣  Save / Load", show_save_load))
	box.add_child(_button("⚙  Opções", show_options))
	var exit_button := _button("Sair", _quit_game)
	box.add_child(exit_button)
	var version := _label("Godot production base 0.1", 14, Color("aab8c4"))
	version.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(version)

func _start_new_game() -> void:
	GameState.reset_run(true)
	feedback_text = "Bem-vindo à PAPO SAPÃO. Entregue a pizza para Ronaldo Gilberto."
	SceneRouter.route_to("reception")
	show_game()

func show_save_load() -> void:
	current_screen = "save_load"
	_clear()
	_background("res://assets/scenarios/menu.png")
	var panel := _center_panel("SAVE / LOAD")
	var box = panel.get_node("Box")
	for slot in range(1, 4):
		var meta := SaveManager.get_slot_metadata(slot)
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 10)
		box.add_child(row)
		var info_text := "Slot %d — vazio" % slot
		if not meta.is_empty():
			info_text = "Slot %d — %s — %s min" % [slot, str(meta.get("area", "?")), str(meta.get("minutes", 0))]
		var info := _label(info_text, 18)
		info.custom_minimum_size = Vector2(380, 54)
		row.add_child(info)
		var save_b := _button("Salvar", _save_slot.bind(slot))
		save_b.custom_minimum_size = Vector2(150, 54)
		save_b.disabled = not GameState.run_active
		row.add_child(save_b)
		var load_b := _button("Carregar", _load_slot.bind(slot), true)
		load_b.custom_minimum_size = Vector2(160, 54)
		load_b.disabled = not SaveManager.has_slot(slot)
		row.add_child(load_b)
	box.add_child(_button("← Voltar", show_menu))

func _save_slot(slot: int) -> void:
	if SaveManager.save_slot(slot):
		feedback_text = "Partida salva no Slot %d." % slot
	show_save_load()

func _load_slot(slot: int) -> void:
	if SaveManager.load_slot(slot):
		feedback_text = "Partida carregada do Slot %d." % slot
		current_screen = "game"
		show_game()

func show_options() -> void:
	current_screen = "options"
	_clear()
	_background("res://assets/scenarios/menu.png")
	var panel := _center_panel("OPÇÕES")
	var box = panel.get_node("Box")
	box.add_child(_label("Volume geral", 18))
	var master := HSlider.new()
	master.min_value = 0.0
	master.max_value = 1.0
	master.step = 0.05
	master.value = float(SettingsManager.get_value("master_volume", 0.85))
	master.custom_minimum_size = Vector2(560, 36)
	master.value_changed.connect(_set_master)
	box.add_child(master)
	box.add_child(_label("Música", 18))
	var music := HSlider.new()
	music.min_value = 0.0
	music.max_value = 1.0
	music.step = 0.05
	music.value = float(SettingsManager.get_value("music_volume", 0.75))
	music.value_changed.connect(_set_music)
	box.add_child(music)
	box.add_child(_label("Efeitos", 18))
	var sfx := HSlider.new()
	sfx.min_value = 0.0
	sfx.max_value = 1.0
	sfx.step = 0.05
	sfx.value = float(SettingsManager.get_value("sfx_volume", 0.85))
	sfx.value_changed.connect(_set_sfx)
	box.add_child(sfx)
	var fullscreen := CheckButton.new()
	fullscreen.text = "Tela cheia"
	fullscreen.button_pressed = bool(SettingsManager.get_value("fullscreen", false))
	fullscreen.add_theme_font_size_override("font_size", 20)
	fullscreen.toggled.connect(_set_fullscreen)
	box.add_child(fullscreen)
	box.add_child(_button("← Voltar", show_menu))

func _set_master(value: float) -> void:
	SettingsManager.set_value("master_volume", value)

func _set_music(value: float) -> void:
	SettingsManager.set_value("music_volume", value)

func _set_sfx(value: float) -> void:
	SettingsManager.set_value("sfx_volume", value)

func _set_fullscreen(value: bool) -> void:
	SettingsManager.set_value("fullscreen", value)

func _center_panel(title_text: String) -> PanelContainer:
	var wrapper := CenterContainer.new()
	wrapper.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(wrapper)
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(780, 0)
	panel.add_theme_stylebox_override("panel", _panel_style())
	wrapper.add_child(panel)
	var box := VBoxContainer.new()
	box.name = "Box"
	box.add_theme_constant_override("separation", 14)
	panel.add_child(box)
	var title := _label(title_text, 40, Color("ffd34e"))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(title)
	return panel

func show_game() -> void:
	current_screen = "game"
	_clear()
	var area := AreaCatalog.get_area(GameState.current_area)
	_background(str(area.get("background", "")))
	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 24)
	margin.add_theme_constant_override("margin_right", 24)
	margin.add_theme_constant_override("margin_top", 20)
	margin.add_theme_constant_override("margin_bottom", 20)
	add_child(margin)
	var vertical := VBoxContainer.new()
	vertical.add_theme_constant_override("separation", 12)
	margin.add_child(vertical)
	var top := HBoxContainer.new()
	vertical.add_child(top)
	var area_title := _label(str(area.get("title", "Área")), 34, Color("ffd34e"))
	area_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.add_child(area_title)
	var pizza_text := "🍕 %s%%  |  %s min  |  %s fatias" % [str(GameState.pizza.get("temperature", 100)), str(GameState.pizza.get("elapsed_minutes", 0)), str(GameState.pizza.get("quantity", 8))]
	top.add_child(_label(pizza_text, 18))
	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vertical.add_child(spacer)
	var bottom := HBoxContainer.new()
	bottom.add_theme_constant_override("separation", 12)
	vertical.add_child(bottom)
	var info_panel := PanelContainer.new()
	info_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info_panel.add_theme_stylebox_override("panel", _panel_style())
	bottom.add_child(info_panel)
	var info_box := VBoxContainer.new()
	info_box.add_theme_constant_override("separation", 9)
	info_panel.add_child(info_box)
	info_box.add_child(_label(str(area.get("description", "")), body_font_size))
	if feedback_text != "":
		var feedback := _label(feedback_text, 17, Color("8ff0d0"))
		info_box.add_child(feedback)
	var inv_value := "vazio"
	if not GameState.inventory.is_empty():
		var parts: Array[String] = []
		for item in GameState.inventory:
			parts.append(str(item))
		inv_value = ", ".join(parts)
	var inv_text := "Inventário: " + inv_value
	info_box.add_child(_label(inv_text, 15, Color("c6d2dc")))
	var action_box := VBoxContainer.new()
	action_box.custom_minimum_size = Vector2(420, 0)
	action_box.add_theme_constant_override("separation", 8)
	bottom.add_child(action_box)
	for action in area.get("actions", []):
		var action_id := str(action[0])
		var action_label := str(action[1])
		action_box.add_child(_button(action_label, _perform_action.bind(action_id), action_id in ["identify", "solve_ti", "solve_supplies", "present_os", "solve_rh", "approve_bolota", "say_director"]))
	var quick := HBoxContainer.new()
	quick.add_theme_constant_override("separation", 8)
	action_box.add_child(quick)
	var save_b := _button("Salvar", _quick_save)
	save_b.custom_minimum_size = Vector2(130, 48)
	quick.add_child(save_b)
	var menu_b := _button("Menu", show_menu)
	menu_b.custom_minimum_size = Vector2(130, 48)
	quick.add_child(menu_b)

func _quick_save() -> void:
	if SaveManager.save_slot(1):
		feedback_text = "Salvo rapidamente no Slot 1."
		show_game()

func _perform_action(action_id: String) -> void:
	feedback_text = ""
	GameFlow.perform(action_id)

func _on_area_changed(_area_id: String) -> void:
	if current_screen == "game":
		call_deferred("show_game")

func _on_feedback(message: String) -> void:
	feedback_text = message
	if current_screen == "game":
		call_deferred("show_game")

func _on_achievement_unlocked(name: String) -> void:
	feedback_text = "🏆 Conquista desbloqueada: " + name
	if current_screen == "game":
		call_deferred("show_game")

func _on_finished(ending_name: String, message: String) -> void:
	show_ending(ending_name, message)

func show_ending(ending_name: String, message: String) -> void:
	current_screen = "ending"
	_clear()
	_background("res://assets/scenarios/directorate.png")
	var panel := _center_panel(ending_name)
	var box = panel.get_node("Box")
	var msg := _label(message, 22)
	msg.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(msg)
	if ending_name == "ENTREGA CONCLUÍDA":
		var stamp := _label("NOVO PROTOCOLO INICIADO", 28, Color("8ff0d0"))
		stamp.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		box.add_child(stamp)
	box.add_child(_button("Novo Jogo", _start_new_game, true))
	box.add_child(_button("Menu Principal", show_menu))

func _quit_game() -> void:
	get_tree().quit()
