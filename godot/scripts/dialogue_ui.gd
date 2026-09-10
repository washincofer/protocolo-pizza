extends Node

signal choice_selected(dialogue_id: String, choice_id: String)

const SPEECH_SMALL_PATH: String = "res://assets/ui/speech/speech_small.png"
const SPEECH_MEDIUM_PATH: String = "res://assets/ui/speech/speech_medium.png"
const SPEECH_LARGE_PATH: String = "res://assets/ui/speech/speech_large.png"
const CHOICE_PANEL_PATH: String = "res://assets/ui/dialogue/choice_panel.png"

var layer: CanvasLayer
var speech_layer: CanvasLayer
var current_dialogue_id: String = ""
var current_choices: Dictionary = {}
var speech_generation: int = 0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_process_unhandled_key_input(true)

func open_dialogue(
	dialogue_id: String,
	speaker: String,
	text: String,
	choices: Array,
	anchor_image_position: Vector2 = Vector2(-1, -1)
) -> void:
	close_dialogue()
	close_speech()
	current_dialogue_id = dialogue_id
	current_choices = {}

	layer = CanvasLayer.new()
	layer.layer = 940
	add_child(layer)

	var blocker: ColorRect = ColorRect.new()
	blocker.color = Color(0, 0, 0, 0.08)
	blocker.mouse_filter = Control.MOUSE_FILTER_STOP
	blocker.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	layer.add_child(blocker)

	_build_speech_balloon(layer, speaker, text, anchor_image_position)
	_build_choice_panel(layer, dialogue_id, choices)

func show_speech(
	speaker: String,
	text: String,
	anchor_image_position: Vector2 = Vector2(-1, -1),
	seconds: float = 4.2
) -> void:
	close_speech()
	speech_generation += 1
	var generation: int = speech_generation
	speech_layer = CanvasLayer.new()
	speech_layer.layer = 935
	add_child(speech_layer)
	_build_speech_balloon(speech_layer, speaker, text, anchor_image_position)
	var timer: SceneTreeTimer = get_tree().create_timer(seconds, true, false, true)
	timer.timeout.connect(func() -> void:
		if generation == speech_generation:
			close_speech()
	)

func close_dialogue() -> void:
	if layer != null:
		layer.queue_free()
		layer = null
	current_dialogue_id = ""
	current_choices = {}

func close_speech() -> void:
	speech_generation += 1
	if speech_layer != null:
		speech_layer.queue_free()
		speech_layer = null

func is_open() -> bool:
	return layer != null

func _unhandled_key_input(event: InputEvent) -> void:
	if layer == null or current_choices.is_empty():
		return
	var key_event: InputEventKey = event as InputEventKey
	if key_event == null or not key_event.pressed or key_event.echo:
		return
	var key: String = ""
	match key_event.keycode:
		KEY_A:
			key = "A"
		KEY_B:
			key = "B"
		KEY_C:
			key = "C"
		KEY_D:
			key = "D"
		_:
			return
	if current_choices.has(key):
		_select(current_dialogue_id, str(current_choices[key]))
		get_viewport().set_input_as_handled()

func _build_speech_balloon(
	parent_layer: CanvasLayer,
	speaker: String,
	text: String,
	anchor_image_position: Vector2
) -> void:
	var view_size: Vector2 = get_viewport().get_visible_rect().size
	var variant: String = _speech_variant(text)
	var bubble_size: Vector2 = _speech_size(variant, view_size)
	var anchor: Vector2 = _image_to_screen(anchor_image_position)
	if anchor.x < 0.0 or anchor.y < 0.0:
		anchor = Vector2(view_size.x * 0.5, view_size.y * 0.43)
	var bubble_position: Vector2 = anchor - Vector2(bubble_size.x * 0.5, bubble_size.y + 18.0)
	bubble_position.x = clampf(bubble_position.x, 16.0, maxf(16.0, view_size.x - bubble_size.x - 16.0))
	bubble_position.y = clampf(bubble_position.y, 12.0, maxf(12.0, view_size.y - bubble_size.y - 330.0))

	var root: Control = Control.new()
	root.position = bubble_position
	root.size = bubble_size
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent_layer.add_child(root)

	var bubble_texture: Texture2D = _load_texture(_speech_path(variant))
	if bubble_texture != null:
		var texture_rect: TextureRect = TextureRect.new()
		texture_rect.texture = bubble_texture
		texture_rect.position = Vector2.ZERO
		texture_rect.size = bubble_size
		texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		texture_rect.stretch_mode = TextureRect.STRETCH_SCALE
		texture_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		root.add_child(texture_rect)
	else:
		var fallback: PanelContainer = PanelContainer.new()
		fallback.position = Vector2.ZERO
		fallback.size = bubble_size
		fallback.mouse_filter = Control.MOUSE_FILTER_IGNORE
		fallback.add_theme_stylebox_override("panel", _balloon_fallback_style())
		root.add_child(fallback)

	var margin: MarginContainer = MarginContainer.new()
	margin.position = Vector2(30, 20)
	margin.size = bubble_size - Vector2(60, 58)
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(margin)

	var box: VBoxContainer = VBoxContainer.new()
	box.add_theme_constant_override("separation", 4)
	box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin.add_child(box)

	var speaker_label: Label = Label.new()
	speaker_label.text = speaker
	speaker_label.add_theme_font_size_override("font_size", 17)
	speaker_label.add_theme_color_override("font_color", Color("1f2933"))
	speaker_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_child(speaker_label)

	var text_label: Label = Label.new()
	text_label.text = text
	text_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	text_label.add_theme_font_size_override("font_size", 18 if variant != "large" else 16)
	text_label.add_theme_color_override("font_color", Color("17202a"))
	text_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	text_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_child(text_label)

func _build_choice_panel(parent_layer: CanvasLayer, dialogue_id: String, choices: Array) -> void:
	var view_size: Vector2 = get_viewport().get_visible_rect().size
	var panel_size: Vector2 = Vector2(minf(view_size.x - 32.0, 1120.0), 300.0)
	var panel_position: Vector2 = Vector2((view_size.x - panel_size.x) * 0.5, view_size.y - panel_size.y - 12.0)

	var root: Control = Control.new()
	root.position = panel_position
	root.size = panel_size
	parent_layer.add_child(root)

	var panel_texture: Texture2D = _load_texture(CHOICE_PANEL_PATH)
	if panel_texture != null:
		var texture_rect: TextureRect = TextureRect.new()
		texture_rect.texture = panel_texture
		texture_rect.position = Vector2.ZERO
		texture_rect.size = panel_size
		texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		texture_rect.stretch_mode = TextureRect.STRETCH_SCALE
		texture_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		root.add_child(texture_rect)
	else:
		var fallback: PanelContainer = PanelContainer.new()
		fallback.position = Vector2.ZERO
		fallback.size = panel_size
		fallback.mouse_filter = Control.MOUSE_FILTER_IGNORE
		fallback.add_theme_stylebox_override("panel", _panel_style())
		root.add_child(fallback)

	var cells: Array[Rect2] = [
		Rect2(panel_size.x * 0.105, panel_size.y * 0.17, panel_size.x * 0.385, panel_size.y * 0.29),
		Rect2(panel_size.x * 0.515, panel_size.y * 0.17, panel_size.x * 0.385, panel_size.y * 0.29),
		Rect2(panel_size.x * 0.105, panel_size.y * 0.535, panel_size.x * 0.385, panel_size.y * 0.29),
		Rect2(panel_size.x * 0.515, panel_size.y * 0.535, panel_size.x * 0.385, panel_size.y * 0.29)
	]

	for index: int in range(mini(choices.size(), 4)):
		var choice: Dictionary = Dictionary(choices[index])
		var key: String = str(choice.get("key", char(65 + index)))
		var choice_id: String = str(choice.get("id", key))
		current_choices[key.to_upper()] = choice_id
		_build_choice_button(root, cells[index], dialogue_id, choice_id, key, str(choice.get("text", "")), panel_texture != null)

func _build_choice_button(
	parent: Control,
	cell: Rect2,
	dialogue_id: String,
	choice_id: String,
	key: String,
	text: String,
	has_art_panel: bool
) -> void:
	var button: Button = Button.new()
	button.position = cell.position
	button.size = cell.size
	button.text = ""
	button.focus_mode = Control.FOCUS_NONE
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	button.add_theme_stylebox_override("normal", _choice_style(false))
	button.add_theme_stylebox_override("hover", _choice_style(true))
	button.add_theme_stylebox_override("pressed", _choice_style(true))
	button.pressed.connect(_select.bind(dialogue_id, choice_id))
	parent.add_child(button)

	var label: Label = Label.new()
	label.position = Vector2(72.0 if has_art_panel else 14.0, 4.0)
	label.size = Vector2(cell.size.x - (82.0 if has_art_panel else 28.0), cell.size.y - 8.0)
	label.text = text if has_art_panel else "%s - %s" % [key, text]
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	label.add_theme_font_size_override("font_size", 16)
	label.add_theme_color_override("font_color", Color("17202a") if has_art_panel else Color.WHITE)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	button.add_child(label)

func _select(dialogue_id: String, choice_id: String) -> void:
	close_dialogue()
	choice_selected.emit(dialogue_id, choice_id)

func _speech_variant(text: String) -> String:
	var length: int = text.length()
	if length <= 75:
		return "small"
	if length <= 180:
		return "medium"
	return "large"

func _speech_size(variant: String, view_size: Vector2) -> Vector2:
	match variant:
		"small":
			return Vector2(minf(330.0, view_size.x - 32.0), 170.0)
		"medium":
			return Vector2(minf(470.0, view_size.x - 32.0), 210.0)
		_:
			return Vector2(minf(650.0, view_size.x - 32.0), 240.0)

func _speech_path(variant: String) -> String:
	match variant:
		"small":
			return SPEECH_SMALL_PATH
		"medium":
			return SPEECH_MEDIUM_PATH
		_:
			return SPEECH_LARGE_PATH

func _image_to_screen(image_position: Vector2) -> Vector2:
	if image_position.x < 0.0 or image_position.y < 0.0:
		return Vector2(-1, -1)
	var current: Node = get_tree().current_scene
	if not (current is Control):
		return Vector2(-1, -1)
	for child: Node in current.get_children():
		if child is TextureRect:
			var bg: TextureRect = child as TextureRect
			if bg.texture == null or bg.size.x <= 0.0 or bg.size.y <= 0.0:
				continue
			var source_size: Vector2 = Vector2(bg.texture.get_size())
			return bg.position + Vector2(
				image_position.x * bg.size.x / maxf(source_size.x, 1.0),
				image_position.y * bg.size.y / maxf(source_size.y, 1.0)
			)
	return Vector2(-1, -1)

func _load_texture(path: String) -> Texture2D:
	if not ResourceLoader.exists(path):
		return null
	var resource: Resource = load(path)
	if resource is Texture2D:
		return resource as Texture2D
	return null

func _choice_style(hovered: bool) -> StyleBoxFlat:
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = Color(1.0, 0.82, 0.2, 0.12) if hovered else Color(1, 1, 1, 0)
	style.border_color = Color(1.0, 0.72, 0.12, 0.85) if hovered else Color(1, 1, 1, 0)
	style.set_border_width_all(2 if hovered else 0)
	style.corner_radius_top_left = 12
	style.corner_radius_top_right = 12
	style.corner_radius_bottom_left = 12
	style.corner_radius_bottom_right = 12
	return style

func _balloon_fallback_style() -> StyleBoxFlat:
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = Color(1.0, 0.97, 0.86, 0.98)
	style.border_color = Color(0.08, 0.10, 0.12, 0.95)
	style.set_border_width_all(3)
	style.corner_radius_top_left = 22
	style.corner_radius_top_right = 22
	style.corner_radius_bottom_left = 22
	style.corner_radius_bottom_right = 22
	return style

func _panel_style() -> StyleBoxFlat:
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = Color(0.025, 0.05, 0.08, 0.96)
	style.border_color = Color(1.0, 0.78, 0.18, 0.9)
	style.set_border_width_all(2)
	style.corner_radius_top_left = 18
	style.corner_radius_top_right = 18
	style.corner_radius_bottom_left = 18
	style.corner_radius_bottom_right = 18
	return style
