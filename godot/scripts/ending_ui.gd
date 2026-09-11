extends Node

const UIAssets = preload("res://scripts/ui_asset_catalog.gd")

var overlay_layer: CanvasLayer = null
var pending_achievements: Array[String] = []

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	AchievementManager.achievement_unlocked.connect(_on_achievement_unlocked)
	GameFlow.feedback.connect(_on_game_feedback)
	GameFlow.finished.connect(_on_game_finished)

func _on_achievement_unlocked(achievement_name: String) -> void:
	if achievement_name not in pending_achievements:
		pending_achievements.append(achievement_name)

func _on_game_feedback(_text: String) -> void:
	# Conquistas obtidas durante o jogo normal não devem aparecer como se
	# tivessem sido concedidas por um final posterior.
	pending_achievements.clear()

func _on_game_finished(ending_name: String, message: String) -> void:
	var ending_achievements: Array[String] = pending_achievements.duplicate()
	pending_achievements.clear()
	_show_ending(ending_name, message, ending_achievements)

func _show_ending(ending_name: String, message: String, ending_achievements: Array[String]) -> void:
	_close_overlay()
	DialogueUI.close_dialogue()
	DialogueUI.close_speech()

	overlay_layer = CanvasLayer.new()
	overlay_layer.layer = 945
	add_child(overlay_layer)

	var shade: ColorRect = ColorRect.new()
	shade.color = Color(0.01, 0.02, 0.035, 0.88)
	shade.mouse_filter = Control.MOUSE_FILTER_STOP
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay_layer.add_child(shade)

	var center: CenterContainer = CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	overlay_layer.add_child(center)

	var view_size: Vector2 = get_viewport().get_visible_rect().size
	var panel: PanelContainer = PanelContainer.new()
	panel.custom_minimum_size = Vector2(minf(860.0, view_size.x - 48.0), minf(610.0, view_size.y - 42.0))
	panel.add_theme_stylebox_override("panel", _ending_panel_style())
	center.add_child(panel)

	var margin: MarginContainer = MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 34)
	margin.add_theme_constant_override("margin_right", 34)
	margin.add_theme_constant_override("margin_top", 24)
	margin.add_theme_constant_override("margin_bottom", 24)
	panel.add_child(margin)

	var outer: VBoxContainer = VBoxContainer.new()
	outer.add_theme_constant_override("separation", 11)
	margin.add_child(outer)

	var canonical: bool = ending_name == "ENTREGA CONCLUÍDA"
	var eyebrow: Label = Label.new()
	eyebrow.text = "MISSÃO CUMPRIDA" if canonical else "FINAL ABSURDO"
	eyebrow.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	eyebrow.add_theme_font_size_override("font_size", 18)
	eyebrow.add_theme_color_override("font_color", Color("ffd34e"))
	outer.add_child(eyebrow)

	var title: Label = Label.new()
	title.text = ending_name
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	title.add_theme_font_size_override("font_size", 38 if ending_name.length() < 25 else 31)
	title.add_theme_color_override("font_color", Color("fff4cf"))
	outer.add_child(title)

	var rule_top: HSeparator = HSeparator.new()
	outer.add_child(rule_top)

	var body: Label = Label.new()
	body.text = message
	body.custom_minimum_size = Vector2(0, 74)
	body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	body.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	body.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	body.add_theme_font_size_override("font_size", 19)
	body.add_theme_color_override("font_color", Color("eaf0f5"))
	outer.add_child(body)

	var stats: Label = Label.new()
	stats.text = "FINAIS DESCOBERTOS  %d / %d     •     CONQUISTAS  %d / %d" % [
		EndingManager.seen.size(),
		EndingManager.CATALOG.size(),
		AchievementManager.unlocked_names.size(),
		AchievementManager.CATALOG.size()
	]
	stats.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	stats.add_theme_font_size_override("font_size", 15)
	stats.add_theme_color_override("font_color", Color("aeb9c4"))
	outer.add_child(stats)

	if not ending_achievements.is_empty():
		_build_achievement_card(outer, ending_achievements)
	else:
		_build_registered_card(outer)

	var spacer: Control = Control.new()
	spacer.custom_minimum_size = Vector2(1, 2)
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	outer.add_child(spacer)

	var buttons: HBoxContainer = HBoxContainer.new()
	buttons.alignment = BoxContainer.ALIGNMENT_CENTER
	buttons.add_theme_constant_override("separation", 12)
	outer.add_child(buttons)

	var restart: Button = _ending_button("Nova partida", true)
	restart.pressed.connect(_new_game)
	buttons.add_child(restart)

	var achievements: Button = _ending_button("Ver conquistas", false)
	achievements.pressed.connect(_open_achievements)
	buttons.add_child(achievements)

	var menu: Button = _ending_button("Menu principal", false)
	menu.pressed.connect(_go_to_menu)
	buttons.add_child(menu)

func _build_achievement_card(parent: VBoxContainer, achievements: Array[String]) -> void:
	var card: PanelContainer = PanelContainer.new()
	card.custom_minimum_size = Vector2(0, 116)
	card.add_theme_stylebox_override("panel", _achievement_style())
	parent.add_child(card)

	var margin: MarginContainer = MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 20)
	margin.add_theme_constant_override("margin_right", 20)
	margin.add_theme_constant_override("margin_top", 13)
	margin.add_theme_constant_override("margin_bottom", 13)
	card.add_child(margin)

	var row: HBoxContainer = HBoxContainer.new()
	row.add_theme_constant_override("separation", 18)
	margin.add_child(row)

	var trophy_texture: Texture2D = UIAssets.load_texture(UIAssets.TROPHY_ICON)
	if trophy_texture != null:
		var trophy: TextureRect = TextureRect.new()
		trophy.texture = trophy_texture
		trophy.custom_minimum_size = Vector2(78, 78)
		trophy.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		trophy.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		trophy.mouse_filter = Control.MOUSE_FILTER_IGNORE
		row.add_child(trophy)
	else:
		var trophy_fallback: Label = Label.new()
		trophy_fallback.text = "🏆"
		trophy_fallback.custom_minimum_size = Vector2(78, 78)
		trophy_fallback.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		trophy_fallback.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		trophy_fallback.add_theme_font_size_override("font_size", 44)
		row.add_child(trophy_fallback)

	var text_box: VBoxContainer = VBoxContainer.new()
	text_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	text_box.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_child(text_box)

	var caption: Label = Label.new()
	caption.text = "CONQUISTAS DESBLOQUEADAS" if achievements.size() > 1 else "CONQUISTA DESBLOQUEADA"
	caption.add_theme_font_size_override("font_size", 15)
	caption.add_theme_color_override("font_color", Color("ffd34e"))
	text_box.add_child(caption)

	var names: Label = Label.new()
	names.text = "\n".join(achievements)
	names.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	names.add_theme_font_size_override("font_size", 23 if achievements.size() == 1 else 18)
	names.add_theme_color_override("font_color", Color("fff4cf"))
	text_box.add_child(names)

func _build_registered_card(parent: VBoxContainer) -> void:
	var card: PanelContainer = PanelContainer.new()
	card.custom_minimum_size = Vector2(0, 74)
	card.add_theme_stylebox_override("panel", _registered_style())
	parent.add_child(card)

	var label: Label = Label.new()
	label.text = "FINAL REGISTRADO NO ARQUIVO DA PAPO SAPÃO"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 17)
	label.add_theme_color_override("font_color", Color("c7d1da"))
	card.add_child(label)

func _ending_button(text_value: String, primary: bool) -> Button:
	var button: Button = Button.new()
	button.text = text_value
	button.custom_minimum_size = Vector2(205, 52)
	button.focus_mode = Control.FOCUS_NONE
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	button.add_theme_font_size_override("font_size", 17)
	button.add_theme_stylebox_override("normal", _button_style(primary, false))
	button.add_theme_stylebox_override("hover", _button_style(primary, true))
	button.add_theme_stylebox_override("pressed", _button_style(primary, true))
	return button

func _new_game() -> void:
	_close_overlay()
	pending_achievements.clear()
	GameState.reset_run(true)
	SceneRouter.route_to("reception")

func _open_achievements() -> void:
	AchievementsUI.open(false)

func _go_to_menu() -> void:
	_close_overlay()
	pending_achievements.clear()
	var current: Node = get_tree().current_scene
	if current != null and current.has_method("show_menu"):
		current.call("show_menu")

func _close_overlay() -> void:
	if overlay_layer != null and is_instance_valid(overlay_layer):
		overlay_layer.queue_free()
	overlay_layer = null

func _ending_panel_style() -> StyleBoxFlat:
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = Color("111820f5")
	style.border_color = Color("f3c548")
	style.set_border_width_all(3)
	style.corner_radius_top_left = 24
	style.corner_radius_top_right = 24
	style.corner_radius_bottom_left = 24
	style.corner_radius_bottom_right = 24
	style.shadow_color = Color(0, 0, 0, 0.55)
	style.shadow_size = 18
	return style

func _achievement_style() -> StyleBoxFlat:
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = Color("2b2412ee")
	style.border_color = Color("ffd34e")
	style.set_border_width_all(2)
	style.corner_radius_top_left = 18
	style.corner_radius_top_right = 18
	style.corner_radius_bottom_left = 18
	style.corner_radius_bottom_right = 18
	return style

func _registered_style() -> StyleBoxFlat:
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = Color("18222ddd")
	style.border_color = Color("667788")
	style.set_border_width_all(1)
	style.corner_radius_top_left = 14
	style.corner_radius_top_right = 14
	style.corner_radius_bottom_left = 14
	style.corner_radius_bottom_right = 14
	return style

func _button_style(primary: bool, hovered: bool) -> StyleBoxFlat:
	var style: StyleBoxFlat = StyleBoxFlat.new()
	if primary:
		style.bg_color = Color("f3c548") if not hovered else Color("ffd966")
		style.border_color = Color("fff1b0")
	else:
		style.bg_color = Color("202c38") if not hovered else Color("2d3e4e")
		style.border_color = Color("647789")
	style.set_border_width_all(2)
	style.corner_radius_top_left = 12
	style.corner_radius_top_right = 12
	style.corner_radius_bottom_left = 12
	style.corner_radius_bottom_right = 12
	return style
