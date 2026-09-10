extends Node

# Ajustes temporários do piloto visual da Recepção.
# Depois de aprovados em teste, estes valores podem virar o padrão geral da UI.
const RECEPTION_SPEECH_IMAGE_DELTA: Vector2 = Vector2(52.0, -58.0)
const CHOICE_PANEL_SCALE: float = 0.20
const HUD_ICON_MAX_WIDTH: int = 10
const HUD_ICON_CLICK_SIZE: Vector2 = Vector2(32.0, 32.0)
const HUD_RIGHT_MARGIN: float = 12.0
const HUD_ICON_GAP: float = 4.0
const SPEECH_ADJUSTED_META: StringName = &"reception_speech_fine_tuned"

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

	if menu_button != null:
		menu_button.size = HUD_ICON_CLICK_SIZE
		menu_button.icon_max_width = HUD_ICON_MAX_WIDTH
		menu_button.flat = true
		menu_button.position = Vector2(
			view_size.x - HUD_RIGHT_MARGIN - HUD_ICON_CLICK_SIZE.x,
			12.0
		)

	if trophy_button != null:
		trophy_button.size = HUD_ICON_CLICK_SIZE
		trophy_button.icon_max_width = HUD_ICON_MAX_WIDTH
		trophy_button.flat = true
		var menu_x: float = view_size.x - HUD_RIGHT_MARGIN - HUD_ICON_CLICK_SIZE.x
		trophy_button.position = Vector2(
			menu_x - HUD_ICON_GAP - HUD_ICON_CLICK_SIZE.x,
			12.0
		)

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
