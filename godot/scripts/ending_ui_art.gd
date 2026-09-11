extends Node

const HUD_PATH: String = "res://assets/ui/endings/ending_hud.png"
const ART_SIZE := Vector2(1664.0, 936.0)

const CATEGORY_RECT := Rect2(565, 176, 540, 78)
const TITLE_RECT := Rect2(430, 290, 1090, 64)
const MESSAGE_RECT := Rect2(430, 360, 1090, 116)
const STATS_RECT := Rect2(430, 484, 1090, 34)
const REWARD_RECT := Rect2(430, 520, 1090, 54)
const RIBBON_RECT := Rect2(75, 505, 310, 58)
const BUTTON_RECTS := [
	Rect2(74, 596, 742, 122),
	Rect2(828, 596, 742, 122),
	Rect2(74, 730, 742, 122),
	Rect2(828, 730, 742, 122)
]

var overlay_layer: CanvasLayer = null
var archive_layer: CanvasLayer = null
var pending_achievements: Array[String] = []

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	AchievementManager.achievement_unlocked.connect(_on_achievement)
	GameFlow.feedback.connect(_on_feedback)
	GameFlow.finished.connect(_on_finished)

func _on_achievement(name: String) -> void:
	if name not in pending_achievements:
		pending_achievements.append(name)

func _on_feedback(_text: String) -> void:
	pending_achievements.clear()

func _on_finished(ending_name: String, message: String) -> void:
	var earned: Array[String] = []
	for name: String in pending_achievements:
		earned.append(name)
	pending_achievements.clear()
	_show(ending_name, message, earned)

func _show(ending_name: String, message: String, earned: Array[String]) -> void:
	_close_archive()
	_close_overlay()
	DialogueUI.close_dialogue()
	DialogueUI.close_speech()
	var texture := _load_texture(HUD_PATH)
	if texture == null:
		return

	overlay_layer = CanvasLayer.new()
	overlay_layer.layer = 945
	add_child(overlay_layer)

	var blocker := ColorRect.new()
	blocker.color = Color(0, 0, 0, 0.82)
	blocker.mouse_filter = Control.MOUSE_FILTER_STOP
	blocker.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay_layer.add_child(blocker)

	var art := TextureRect.new()
	art.texture = texture
	art.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	art.stretch_mode = TextureRect.STRETCH_SCALE
	art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	overlay_layer.add_child(art)

	var canonical := ending_name == "ENTREGA CONCLUÍDA"
	_label("MISSÃO CUMPRIDA" if canonical else "FINAL ABSURDO", CATEGORY_RECT, 26, Color("17202a"))
	_label(ending_name, TITLE_RECT, 31 if ending_name.length() < 26 else 26, Color("17202a"), true)
	_label(message, MESSAGE_RECT, 18, Color("29323b"), true)
	_label("FINAIS %d/%d   •   CONQUISTAS %d/%d" % [EndingManager.seen.size(), EndingManager.CATALOG.size(), AchievementManager.unlocked_names.size(), AchievementManager.CATALOG.size()], STATS_RECT, 15, Color("58636d"))

	if earned.is_empty():
		_label("FINAL", RIBBON_RECT, 18, Color.WHITE)
		_label("FINAL REGISTRADO NO ARQUIVO DA PAPO SAPÃO", REWARD_RECT, 16, Color("58636d"))
	else:
		_label("CONQUISTA!", RIBBON_RECT, 17, Color.WHITE)
		_label("CONQUISTA DESBLOQUEADA — %s" % _join(earned), REWARD_RECT, 18, Color("7a4a00"), true)

	_action_button(BUTTON_RECTS[0], "Nova partida", _new_game)
	_action_button(BUTTON_RECTS[1], "Conquistas", _open_achievements)
	_action_button(BUTTON_RECTS[2], "Menu principal", _go_to_menu)
	_action_button(BUTTON_RECTS[3], "Ver finais", _open_archive)

func _label(text_value: String, source_rect: Rect2, font_size: int, color: Color, wrap: bool = false) -> void:
	var rect := _screen_rect(source_rect)
	var label := Label.new()
	label.position = rect.position
	label.size = rect.size
	label.text = text_value
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART if wrap else TextServer.AUTOWRAP_OFF
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_font_size_override("font_size", _font_size(font_size))
	label.add_theme_color_override("font_color", color)
	overlay_layer.add_child(label)

func _action_button(source_rect: Rect2, text_value: String, callback: Callable) -> void:
	var rect := _screen_rect(source_rect)
	var button := Button.new()
	button.text = ""
	button.position = rect.position
	button.size = rect.size
	button.focus_mode = Control.FOCUS_NONE
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	button.add_theme_stylebox_override("normal", _button_style(false))
	button.add_theme_stylebox_override("hover", _button_style(true))
	button.add_theme_stylebox_override("pressed", _button_style(true))
	button.pressed.connect(callback)
	overlay_layer.add_child(button)

	var label := Label.new()
	label.position = Vector2(rect.size.x * 0.18, 0)
	label.size = Vector2(rect.size.x * 0.76, rect.size.y)
	label.text = text_value
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_font_size_override("font_size", _font_size(21))
	label.add_theme_color_override("font_color", Color("17202a"))
	button.add_child(label)

func _screen_rect(source: Rect2) -> Rect2:
	var view := get_viewport().get_visible_rect().size
	var sx := view.x / ART_SIZE.x
	var sy := view.y / ART_SIZE.y
	return Rect2(Vector2(source.position.x * sx, source.position.y * sy), Vector2(source.size.x * sx, source.size.y * sy))

func _font_size(base: int) -> int:
	var view := get_viewport().get_visible_rect().size
	var factor := minf(view.x / 1280.0, view.y / 720.0)
	return maxi(12, int(round(base * factor)))

func _button_style(hovered: bool) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(1.0, 0.78, 0.16, 0.18) if hovered else Color(1, 1, 1, 0)
	style.border_color = Color(1.0, 0.72, 0.10, 0.78) if hovered else Color(1, 1, 1, 0)
	style.set_border_width_all(3 if hovered else 0)
	style.corner_radius_top_left = 18
	style.corner_radius_top_right = 18
	style.corner_radius_bottom_left = 18
	style.corner_radius_bottom_right = 18
	return style

func _join(items: Array[String]) -> String:
	var parts := PackedStringArray()
	for item: String in items:
		parts.append(item)
	return " • ".join(parts)

func _new_game() -> void:
	_close_archive()
	_close_overlay()
	GameState.reset_run(true)
	SceneRouter.route_to("reception")

func _open_achievements() -> void:
	AchievementsUI.open(false)

func _go_to_menu() -> void:
	_close_archive()
	_close_overlay()
	var current := get_tree().current_scene
	if current != null and current.has_method("show_menu"):
		current.call("show_menu")

func _open_archive() -> void:
	_close_archive()
	archive_layer = CanvasLayer.new()
	archive_layer.layer = 960
	add_child(archive_layer)

	var shade := ColorRect.new()
	shade.color = Color(0, 0, 0, 0.80)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	archive_layer.add_child(shade)

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	archive_layer.add_child(center)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(760, 560)
	panel.add_theme_stylebox_override("panel", _archive_style())
	center.add_child(panel)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)
	panel.add_child(box)

	var title := Label.new()
	title.text = "ARQUIVO DE FINAIS — %d/%d" % [EndingManager.seen.size(), EndingManager.CATALOG.size()]
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 28)
	title.add_theme_color_override("font_color", Color("ffd34e"))
	box.add_child(title)

	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(700, 440)
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	box.add_child(scroll)
	var list := VBoxContainer.new()
	list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(list)
	for value in EndingManager.CATALOG:
		var ending_title := str(value)
		var discovered := ending_title in EndingManager.seen
		var row := Label.new()
		row.text = "✓  %s" % ending_title if discovered else "•  ???"
		row.add_theme_font_size_override("font_size", 16)
		row.add_theme_color_override("font_color", Color("fff1b0") if discovered else Color("66717b"))
		list.add_child(row)

	var back := Button.new()
	back.text = "Voltar"
	back.custom_minimum_size = Vector2(220, 46)
	back.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	back.pressed.connect(_close_archive)
	box.add_child(back)

func _archive_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color("111820f5")
	style.border_color = Color("f3c548")
	style.set_border_width_all(3)
	style.corner_radius_top_left = 22
	style.corner_radius_top_right = 22
	style.corner_radius_bottom_left = 22
	style.corner_radius_bottom_right = 22
	return style

func _close_archive() -> void:
	if archive_layer != null and is_instance_valid(archive_layer):
		archive_layer.queue_free()
	archive_layer = null

func _close_overlay() -> void:
	if overlay_layer != null and is_instance_valid(overlay_layer):
		overlay_layer.queue_free()
	overlay_layer = null

func _load_texture(path: String) -> Texture2D:
	if not ResourceLoader.exists(path):
		return null
	var resource := load(path)
	if resource is Texture2D:
		return resource as Texture2D
	return null
