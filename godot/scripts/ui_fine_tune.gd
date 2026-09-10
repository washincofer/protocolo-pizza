extends Node

# Ajustes temporários do piloto visual da Recepção.
# Depois de aprovados em teste, estes valores podem virar o padrão geral da UI.
const RECEPTION_SPEECH_IMAGE_DELTA: Vector2 = Vector2(72.0, -58.0)
const CHOICE_PANEL_SCALE: float = 0.26
const HUD_ICON_VISUAL_SIZE: Vector2 = Vector2(10.0, 10.0)
const HUD_ICON_CLICK_SIZE: Vector2 = Vector2(28.0, 28.0)
const HUD_RIGHT_MARGIN: float = 18.0
const HUD_ICON_GAP: float = 8.0
const HUD_ICON_TOP: float = 16.0
const SPEECH_ADJUSTED_META: StringName = &"reception_speech_fine_tuned"
const HUD_FINE_ICON_NAME: StringName = &"FineTuneVisualIcon"

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	process_priority = 145
	set_process(true)

func _process(_delta: float) -> void:
	var main: Control = _get_main()
	if main == null:
		return
	_fit_hud_icons(main)
	if not GameState.run_active or GameState.current_area != "reception":
		return
	_fit_dialogue_layer(DialogueUI.layer, main)
	_fit_dialogue_layer(DialogueUI.speech_layer, main)

func _get_main() -> Control:
	var current: Node = get_tree().current_scene
	if current is Control:
		return current as Control
	return null

func _fit_hud_icons(main: Control) -> void:
	if not GameState.run_active:
		return
	var view_size: Vector2 = get_viewport().get_visible_rect().size
	var menu_node: Node = main.get_node_or_null("HUDMenuButton")
	var trophy_node: Node = main.get_node_or_null("HUDTrophyButton")
	var menu_button: Button = menu_node as Button
	var trophy_button: Button = trophy_node as Button

	var menu_x: float = view_size.x - HUD_RIGHT_MARGIN - HUD_ICON_CLICK_SIZE.x
	if menu_button != null:
		_fit_hud_button(menu_button)
		menu_button.position = Vector2(menu_x, HUD_ICON_TOP)

	if trophy_button != null:
		_fit_hud_button(trophy_button)
		trophy_button.position = Vector2(
			menu_x - HUD_ICON_GAP - HUD_ICON_CLICK_SIZE.x,
			HUD_ICON_TOP
		)

func _fit_hud_button(button: Button) -> void:
	button.custom_minimum_size = Vector2.ZERO
	button.size = HUD_ICON_CLICK_SIZE
	button.flat = true
	button.clip_contents = false
	button.text = ""

	var icon_node: TextureRect = button.get_node_or_null(HUD_FINE_ICON_NAME) as TextureRect
	if icon_node == null:
		var source_texture: Texture2D = button.icon
		if source_texture == null:
			return
		button.icon = null
		icon_node = TextureRect.new()
		icon_node.name = HUD_FINE_ICON_NAME
		icon_node.texture = source_texture
		icon_node.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon_node.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon_node.mouse_filter = Control.MOUSE_FILTER_IGNORE
		button.add_child(icon_node)

	icon_node.size = HUD_ICON_VISUAL_SIZE
	icon_node.position = (HUD_ICON_CLICK_SIZE - HUD_ICON_VISUAL_SIZE) * 0.5

func _fit_dialogue_layer(canvas_layer: CanvasLayer, main: Control) -> void:
	if canvas_layer == null or not is_instance_valid(canvas_layer):
		return
	for child: Node in canvas_layer.get_children():
		var control: Control = child as Control
		if control == null or control is ColorRect:
			continue
		if _looks_like_choice_panel(control):
			_fit_choice_panel(control)
		elif _looks_like_speech_balloon(control):
			_shift_speech_balloon(control, main)
			_center_speech_text(control)

func _looks_like_choice_panel(control: Control) -> bool:
	return control.size.x >= 800.0 and control.size.y >= 280.0

func _looks_like_speech_balloon(control: Control) -> bool:
	return control.size.x >= 250.0 and control.size.x <= 700.0 and control.size.y >= 140.0 and control.size.y <= 270.0

func _fit_choice_panel(panel: Control) -> void:
	var view_size: Vector2 = get_viewport().get_visible_rect().size
	panel.scale = Vector2(CHOICE_PANEL_SCALE, CHOICE_PANEL_SCALE)
	var visual_size: Vector2 = panel.size * CHOICE_PANEL_SCALE
	panel.position = Vector2(
		(view_size.x - visual_size.x) * 0.5,
		view_size.y - visual_size.y - 12.0
	)

func _shift_speech_balloon(balloon: Control, main: Control) -> void:
	if bool(balloon.get_meta(SPEECH_ADJUSTED_META, false)):
		return
	var delta_screen: Vector2 = _image_delta_to_screen(main, RECEPTION_SPEECH_IMAGE_DELTA)
	balloon.position += delta_screen
	balloon.set_meta(SPEECH_ADJUSTED_META, true)

func _center_speech_text(balloon: Control) -> void:
	for node: Node in balloon.find_children("*", "Label", true, false):
		var label: Label = node as Label
		if label == null:
			continue
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL

func _image_delta_to_screen(main: Control, image_delta: Vector2) -> Vector2:
	for child: Node in main.get_children():
		if child is TextureRect:
			var bg: TextureRect = child as TextureRect
			if bg.texture == null or bg.size.x <= 0.0 or bg.size.y <= 0.0:
				continue
			var source_size: Vector2 = Vector2(bg.texture.get_size())
			if source_size.x <= 0.0 or source_size.y <= 0.0:
				continue
			return Vector2(
				image_delta.x * bg.size.x / source_size.x,
				image_delta.y * bg.size.y / source_size.y
			)
	return Vector2.ZERO
