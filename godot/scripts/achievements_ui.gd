extends Node

var overlay_layer: CanvasLayer = null
var menu_layer: CanvasLayer = null
var menu_button: Button = null
var return_to_pause: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	process_priority = 120
	set_process(true)

func _process(_delta: float) -> void:
	_update_menu_button()

func _unhandled_key_input(event: InputEvent) -> void:
	var key_event: InputEventKey = event as InputEventKey
	if key_event == null or not key_event.pressed or key_event.echo:
		return
	if key_event.keycode == KEY_ESCAPE and overlay_layer != null:
		_close()
		get_viewport().set_input_as_handled()

func _update_menu_button() -> void:
	var should_show: bool = not GameState.run_active and overlay_layer == null
	if should_show:
		_ensure_menu_button()
		if menu_button != null:
			menu_button.visible = true
	else:
		if menu_button != null:
			menu_button.visible = false

func _ensure_menu_button() -> void:
	if menu_button != null and is_instance_valid(menu_button):
		_position_menu_button()
		return
	menu_layer = CanvasLayer.new()
	menu_layer.layer = 700
	add_child(menu_layer)
	menu_button = Button.new()
	menu_button.text = "Conquistas"
	menu_button.tooltip_text = "Ver progresso das 22 conquistas"
	menu_button.custom_minimum_size = Vector2(190, 50)
	menu_button.add_theme_font_size_override("font_size", 18)
	menu_button.pressed.connect(open.bind(false))
	menu_layer.add_child(menu_button)
	_position_menu_button()

func _position_menu_button() -> void:
	if menu_button == null:
		return
	var view: Vector2 = get_viewport().get_visible_rect().size
	menu_button.position = Vector2(28, view.y - 72)

func open(from_pause: bool = false) -> void:
	return_to_pause = from_pause
	_close_overlay_only()
	overlay_layer = CanvasLayer.new()
	overlay_layer.layer = 950
	add_child(overlay_layer)

	var shade: ColorRect = ColorRect.new()
	shade.color = Color(0, 0, 0, 0.82)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay_layer.add_child(shade)

	var center: CenterContainer = CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay_layer.add_child(center)

	var panel: PanelContainer = PanelContainer.new()
	panel.custom_minimum_size = Vector2(900, 610)
	panel.add_theme_stylebox_override("panel", _panel_style())
	center.add_child(panel)

	var outer: VBoxContainer = VBoxContainer.new()
	outer.add_theme_constant_override("separation", 10)
	panel.add_child(outer)

	var title: Label = Label.new()
	title.text = "CONQUISTAS"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 34)
	title.add_theme_color_override("font_color", Color("ffd34e"))
	outer.add_child(title)

	var unlocked_count: int = AchievementManager.unlocked_names.size()
	var total_count: int = AchievementManager.CATALOG.size()
	var progress: Label = Label.new()
	progress.text = "%d / %d desbloqueadas" % [unlocked_count, total_count]
	progress.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	progress.add_theme_font_size_override("font_size", 20)
	outer.add_child(progress)

	var bar: ProgressBar = ProgressBar.new()
	bar.min_value = 0
	bar.max_value = total_count
	bar.value = unlocked_count
	bar.show_percentage = true
	bar.custom_minimum_size = Vector2(820, 26)
	outer.add_child(bar)

	var scroll: ScrollContainer = ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(820, 430)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	outer.add_child(scroll)

	var list: VBoxContainer = VBoxContainer.new()
	list.custom_minimum_size = Vector2(790, 0)
	list.add_theme_constant_override("separation", 6)
	scroll.add_child(list)

	for index in range(total_count):
		var achievement_name: String = str(AchievementManager.CATALOG[index])
		var unlocked: bool = AchievementManager.is_unlocked(achievement_name)
		list.add_child(_achievement_row(index + 1, achievement_name, unlocked))

	var close_button: Button = Button.new()
	close_button.text = "Voltar"
	close_button.custom_minimum_size = Vector2(820, 48)
	close_button.add_theme_font_size_override("font_size", 18)
	close_button.pressed.connect(_close)
	outer.add_child(close_button)

func _achievement_row(number: int, achievement_name: String, unlocked: bool) -> Control:
	var row: PanelContainer = PanelContainer.new()
	row.custom_minimum_size = Vector2(780, 44)
	var style: StyleBoxFlat = StyleBoxFlat.new()
	if unlocked:
		style.bg_color = Color(0.12, 0.22, 0.13, 0.90)
		style.border_color = Color(1.0, 0.78, 0.18, 0.70)
	else:
		style.bg_color = Color(0.08, 0.09, 0.11, 0.88)
		style.border_color = Color(0.35, 0.37, 0.40, 0.55)
	style.set_border_width_all(1)
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	row.add_theme_stylebox_override("panel", style)

	var line: HBoxContainer = HBoxContainer.new()
	line.add_theme_constant_override("separation", 10)
	row.add_child(line)

	var status: Label = Label.new()
	status.text = "✓" if unlocked else "🔒"
	status.custom_minimum_size = Vector2(38, 40)
	status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	status.add_theme_font_size_override("font_size", 20)
	line.add_child(status)

	var label: Label = Label.new()
	label.text = "%02d. %s" % [number, achievement_name]
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 18)
	label.add_theme_color_override("font_color", Color("fff2c2") if unlocked else Color("969aa1"))
	line.add_child(label)

	var state: Label = Label.new()
	state.text = "DESBLOQUEADA" if unlocked else "BLOQUEADA"
	state.custom_minimum_size = Vector2(145, 40)
	state.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	state.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	state.add_theme_font_size_override("font_size", 13)
	state.add_theme_color_override("font_color", Color("ffd34e") if unlocked else Color("777b82"))
	line.add_child(state)
	return row

func _panel_style() -> StyleBoxFlat:
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = Color(0.03, 0.06, 0.09, 0.97)
	style.border_color = Color(1.0, 0.78, 0.18, 0.82)
	style.set_border_width_all(2)
	style.corner_radius_top_left = 18
	style.corner_radius_top_right = 18
	style.corner_radius_bottom_left = 18
	style.corner_radius_bottom_right = 18
	return style

func _close() -> void:
	var should_return_to_pause: bool = return_to_pause
	return_to_pause = false
	_close_overlay_only()
	if should_return_to_pause and GameState.run_active:
		UIPolish.reopen_pause()

func _close_overlay_only() -> void:
	if overlay_layer != null:
		overlay_layer.queue_free()
		overlay_layer = null
