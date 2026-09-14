extends Node

const UIAssets = preload("res://scripts/ui_asset_catalog.gd")

const GENERIC_SPEECH_ANCHOR: Vector2 = Vector2(560.0, 360.0)
const ITEM_TEXTURE_PREFIX: String = "res://assets/ui/items/"
const VR_WORLD_NODE: StringName = &"WorldItem_VRGlasses"
const VR_WORLD_RECT: Rect2 = Rect2(744.0, 510.0, 76.0, 49.0)

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
	_sync_world_items(main)
	if GameState.current_area != "reception":
		_apply_shared_dialogue_layout(main)

func _get_main() -> Control:
	var current: Node = get_tree().current_scene
	if current is Control:
		return current as Control
	return null

func _find_background(main: Control) -> TextureRect:
	for child: Node in main.get_children():
		if child is TextureRect:
			var bg: TextureRect = child as TextureRect
			if bg.texture != null:
				return bg
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

func _sync_world_items(main: Control) -> void:
	var existing: TextureRect = main.get_node_or_null(VR_WORLD_NODE) as TextureRect
	if GameState.current_area != "innovation":
		if existing != null:
			existing.queue_free()
		return

	var already_collected: bool = GameState.has_item("vr_glasses")
	_set_hotspot_enabled(main, "Óculos VR", not already_collected)
	if already_collected:
		if existing != null:
			existing.queue_free()
		return

	var bg: TextureRect = _find_background(main)
	if bg == null or bg.texture == null:
		return
	var texture: Texture2D = UIAssets.item_texture("vr_glasses")
	if texture == null:
		return
	if existing == null:
		existing = TextureRect.new()
		existing.name = VR_WORLD_NODE
		existing.texture = texture
		existing.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		existing.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		existing.mouse_filter = Control.MOUSE_FILTER_IGNORE
		existing.z_index = 20
		main.add_child(existing)

	var source_size: Vector2 = Vector2(bg.texture.get_size())
	var sx: float = bg.size.x / maxf(source_size.x, 1.0)
	var sy: float = bg.size.y / maxf(source_size.y, 1.0)
	existing.position = bg.position + Vector2(VR_WORLD_RECT.position.x * sx, VR_WORLD_RECT.position.y * sy)
	existing.size = Vector2(VR_WORLD_RECT.size.x * sx, VR_WORLD_RECT.size.y * sy)
	existing.visible = true

func _set_hotspot_enabled(main: Control, tooltip: String, enabled: bool) -> void:
	for child: Node in main.get_children():
		var button: Button = child as Button
		if button == null or button.tooltip_text != tooltip:
			continue
		button.disabled = not enabled
		button.mouse_filter = Control.MOUSE_FILTER_STOP if enabled else Control.MOUSE_FILTER_IGNORE

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
