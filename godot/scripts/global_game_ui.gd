extends Node

const GENERIC_SPEECH_ANCHOR: Vector2 = Vector2(560.0, 360.0)
const ITEM_TEXTURE_PREFIX: String = "res://assets/ui/items/"

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	process_priority = 260
	set_process(true)
	GameFlow.feedback.connect(_on_game_feedback)

func _process(_delta: float) -> void:
	_sanitize_menu_ui()
	var main: Control = _get_main()
	if main == null or not GameState.run_active:
		return
	_hide_legacy_game_hud(main)
	if GameState.current_area != "reception":
		_apply_shared_dialogue_layout(main)

func _get_main() -> Control:
	var current: Node = get_tree().current_scene
	if current is Control:
		return current as Control
	return null

func _hide_legacy_game_hud(main: Control) -> void:
	var bottom_dialogue: Control = main.find_child("HUDBottomDialogue", false, false) as Control
	if bottom_dialogue != null:
		bottom_dialogue.visible = false
	for child: Node in main.get_children():
		var panel: PanelContainer = child as PanelContainer
		if panel == null:
			continue
		var labels: Array[Node] = panel.find_children("*", "Label", true, false)
		for label_node: Node in labels:
			var label: Label = label_node as Label
			if label != null and label.text.contains("Inventário"):
				panel.visible = false
				break

func _apply_shared_dialogue_layout(main: Control) -> void:
	if UIFineTune.has_method("_fit_dialogue_layer"):
		UIFineTune.call("_fit_dialogue_layer", DialogueUI.layer, main)
		UIFineTune.call("_fit_dialogue_layer", DialogueUI.speech_layer, main)

func _sanitize_menu_ui() -> void:
	var menu_ui: Node = get_node_or_null("/root/MenuUI")
	if menu_ui == null:
		return
	var overlay_value: Variant = menu_ui.get("overlay_layer")
	if not (overlay_value is CanvasLayer):
		return
	var overlay: CanvasLayer = overlay_value as CanvasLayer
	var screen_name: String = str(menu_ui.get("current_screen"))
	if screen_name == "pause":
		_hide_quit_button(overlay)
	elif screen_name == "inventory":
		_sanitize_inventory_screen(overlay)

func _hide_quit_button(overlay: CanvasLayer) -> void:
	for node: Node in overlay.find_children("*", "Button", true, false):
		var button: Button = node as Button
		if button != null and button.text == "Sair do jogo":
			button.visible = false
			button.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _sanitize_inventory_screen(overlay: CanvasLayer) -> void:
	var root_node: Node = overlay.get_node_or_null("MenuUIScreen_inventory")
	if not (root_node is Control):
		return
	var root: Control = root_node as Control
	root.clip_contents = true
	for node: Node in root.find_children("*", "TextureRect", true, false):
		var texture_rect: TextureRect = node as TextureRect
		if texture_rect == null or texture_rect.texture == null:
			continue
		var texture_path: String = texture_rect.texture.resource_path
		if texture_path.begins_with(ITEM_TEXTURE_PREFIX):
			texture_rect.visible = false
	var old_safe_preview: Control = root.get_node_or_null("InventorySafePreview") as Control
	if old_safe_preview != null:
		old_safe_preview.visible = false
		old_safe_preview.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_game_feedback(text: String) -> void:
	if not GameState.run_active or GameState.current_area == "reception":
		return
	if DialogueUI.is_open():
		return
	var clean_text: String = text.strip_edges()
	if clean_text.is_empty():
		return
	var speaker: String = "PAPO SAPÃO"
	var message: String = clean_text
	var colon_index: int = clean_text.find(":")
	if colon_index > 0 and colon_index <= 36:
		var possible_speaker: String = clean_text.substr(0, colon_index).strip_edges()
		if not possible_speaker.contains("//"):
			speaker = possible_speaker
			message = clean_text.substr(colon_index + 1).strip_edges()
	DialogueUI.show_speech(speaker, message, GENERIC_SPEECH_ANCHOR)
