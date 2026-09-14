extends Node

const UIAssets = preload("res://scripts/ui_asset_catalog.gd")

const GENERIC_SPEECH_ANCHOR: Vector2 = Vector2(560.0, 360.0)
const ITEM_TEXTURE_PREFIX: String = "res://assets/ui/items/"

const VR_WORLD_NODE: String = "WorldItem_VRGlasses"
const VR_WORLD_RECT: Rect2 = Rect2(744.0, 510.0, 76.0, 49.0)
const STAMP_WORLD_NODE: String = "WorldItem_ExecutiveStamp"
const STAMP_WORLD_RECT: Rect2 = Rect2(504.0, 762.0, 99.0, 66.0)
const ROGER_VR_NODE: String = "WorldItem_RogerVRGlasses"
const ROGER_VR_RECT: Rect2 = Rect2(1317.0, 294.0, 68.0, 52.0)

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
	_suppress_legacy_ti_server_overlay(main)
	if GameState.current_area != "reception":
		_apply_shared_dialogue_layout(main)
	_reposition_area_dialogue(main)

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
	var vr_collected: bool = GameState.has_item("vr_glasses") or GameState.has_flag("vr_collected") or GameState.has_flag("boss_ti_done")
	_sync_pickup_item(main, "innovation", VR_WORLD_NODE, "vr_glasses", VR_WORLD_RECT, "Óculos VR", vr_collected)

	var stamp_collected: bool = GameState.has_item("executive_priority_stamp") or GameState.has_flag("communication_stamp_collected")
	_sync_pickup_item(main, "communication", STAMP_WORLD_NODE, "executive_priority_stamp", STAMP_WORLD_RECT, "Carimbo", stamp_collected)

	_sync_roger_vr(main)

func _sync_pickup_item(
	main: Control,
	area_id: String,
	node_name: String,
	item_id: String,
	world_rect: Rect2,
	hotspot_tooltip: String,
	collected: bool
) -> void:
	var existing: TextureRect = main.get_node_or_null(node_name) as TextureRect
	if GameState.current_area != area_id:
		_remove_world_node(existing)
		return

	_set_hotspot_enabled(main, hotspot_tooltip, not collected)
	if collected:
		_remove_world_node(existing)
		return

	var texture: Texture2D = UIAssets.item_texture(item_id)
	if texture == null:
		return
	_place_world_texture(main, existing, node_name, texture, world_rect, 20, false)

func _sync_roger_vr(main: Control) -> void:
	var existing: TextureRect = main.get_node_or_null(ROGER_VR_NODE) as TextureRect
	if GameState.current_area != "ti" or not GameState.has_flag("boss_ti_done"):
		_remove_world_node(existing)
		return
	var texture: Texture2D = UIAssets.item_texture("vr_glasses")
	if texture == null:
		return
	_place_world_texture(main, existing, ROGER_VR_NODE, texture, ROGER_VR_RECT, 30, true)

func _place_world_texture(
	main: Control,
	existing: TextureRect,
	node_name: String,
	texture: Texture2D,
	world_rect: Rect2,
	z_value: int,
	flip_h: bool
) -> void:
	var bg: TextureRect = _find_background(main)
	if bg == null or bg.texture == null:
		return
	if existing == null:
		existing = TextureRect.new()
		existing.name = node_name
		existing.texture = texture
		existing.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		existing.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		existing.mouse_filter = Control.MOUSE_FILTER_IGNORE
		existing.z_index = z_value
		main.add_child(existing)

	var source_size: Vector2 = Vector2(bg.texture.get_size())
	var sx: float = bg.size.x / maxf(source_size.x, 1.0)
	var sy: float = bg.size.y / maxf(source_size.y, 1.0)
	existing.position = bg.position + Vector2(world_rect.position.x * sx, world_rect.position.y * sy)
	existing.size = Vector2(world_rect.size.x * sx, world_rect.size.y * sy)
	existing.flip_h = flip_h
	existing.visible = true

func _remove_world_node(node: TextureRect) -> void:
	if node != null and is_instance_valid(node):
		node.visible = false
		node.queue_free()

func _set_hotspot_enabled(main: Control, tooltip: String, enabled: bool) -> void:
	for child: Node in main.get_children():
		var button: Button = child as Button
		if button == null or button.tooltip_text != tooltip:
			continue
		button.disabled = not enabled
		button.mouse_filter = Control.MOUSE_FILTER_STOP if enabled else Control.MOUSE_FILTER_IGNORE

func _suppress_legacy_ti_server_overlay(main: Control) -> void:
	if GameState.current_area != "ti":
		return
	var legacy: Button = main.get_node_or_null("SubareaEntry_Servidores") as Button
	if legacy != null:
		legacy.visible = false
		legacy.disabled = true
		legacy.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _apply_shared_dialogue_layout(main: Control) -> void:
	if UIFineTune.has_method("_fit_dialogue_layer"):
		UIFineTune.call("_fit_dialogue_layer", DialogueUI.layer, main)
		UIFineTune.call("_fit_dialogue_layer", DialogueUI.speech_layer, main)

func _reposition_area_dialogue(main: Control) -> void:
	if DialogueUI.layer == null or not is_instance_valid(DialogueUI.layer):
		return
	if GameState.current_area == "reception_auditorium":
		_move_dialogue_balloon(DialogueUI.layer, main, Vector2(1272.0, 310.0))

func _move_dialogue_balloon(layer: CanvasLayer, main: Control, image_anchor: Vector2) -> void:
	if layer.get_child_count() < 2:
		return
	var root: Control = layer.get_child(1) as Control
	if root == null or root.size.x <= 0.0 or root.size.y <= 0.0:
		return
	var anchor: Vector2 = _image_to_screen(main, image_anchor)
	if anchor.x < 0.0 or anchor.y < 0.0:
		return
	var view_size: Vector2 = get_viewport().get_visible_rect().size
	var position: Vector2 = anchor - Vector2(root.size.x * 0.5, root.size.y + 18.0)
	position.x = clampf(position.x, 16.0, maxf(16.0, view_size.x - root.size.x - 16.0))
	position.y = clampf(position.y, 12.0, maxf(12.0, view_size.y - root.size.y - 330.0))
	root.position = position

func _image_to_screen(main: Control, image_position: Vector2) -> Vector2:
	var bg: TextureRect = _find_background(main)
	if bg == null or bg.texture == null or bg.size.x <= 0.0 or bg.size.y <= 0.0:
		return Vector2(-1.0, -1.0)
	var source_size: Vector2 = Vector2(bg.texture.get_size())
	return bg.position + Vector2(
		image_position.x * bg.size.x / maxf(source_size.x, 1.0),
		image_position.y * bg.size.y / maxf(source_size.y, 1.0)
	)

func _feedback_anchor(area: String, speaker: String, text: String) -> Vector2:
	match area:
		"reception_auditorium":
			if speaker.begins_with("Lúcia Pauta"):
				return Vector2(1272.0, 310.0)
			if text.contains("ONBOARDING") or text.contains("slide"):
				return Vector2(624.0, 255.0)
		"innovation":
			if speaker.begins_with("Caio Brusch"):
				return Vector2(866.0, 390.0)
			if speaker.begins_with("Bernardo Nolli"):
				return Vector2(426.0, 430.0)
			if speaker.begins_with("Placa"):
				return Vector2(1489.0, 182.0)
			if text.contains("Óculos VR"):
				return Vector2(782.0, 512.0)
			if text.contains("Pouco colaborativo") or text.contains("Você sai"):
				return Vector2(1149.0, 115.0)
		"ti":
			if speaker.begins_with("Rogério Wilco") or text.contains("CALMA BORIS") or text.contains("PROCESSO CONTORNADO"):
				return Vector2(1337.0, 290.0)
		"communication":
			if speaker.begins_with("Informação adquirida") or text.contains("CC-0001"):
				return Vector2(1317.0, 350.0)
			if speaker.begins_with("Microfone"):
				return Vector2(1106.0, 205.0)
			if text.contains("Carimbo"):
				return Vector2(553.0, 762.0)
	return GENERIC_SPEECH_ANCHOR

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
	var anchor: Vector2 = _feedback_anchor(GameState.current_area, speaker, clean_text)
	DialogueUI.show_speech(speaker, message, anchor)
