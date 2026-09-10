extends Node

const MENU_TEXTURE_PATH: String = "res://assets/scenarios/menu.png"

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	process_priority = -500
	set_process(true)

func _process(_delta: float) -> void:
	var main: Control = _get_main()
	if main == null:
		return
	var bg: TextureRect = _find_background(main)
	if bg != null and bg.texture != null and bg.texture.resource_path == MENU_TEXTURE_PATH:
		_prepare_main_menu(main)
	_apply_interaction_lock(main)

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

func _prepare_main_menu(main: Control) -> void:
	if GameState.run_active:
		GameState.reset_run(false)
	if DialogueUI.is_open():
		DialogueUI.close_dialogue()
	DialogueUI.close_speech()
	_cleanup_subarea_nodes(main)
	if UIPolish.has_method("_apply_menu_hotspots"):
		UIPolish.call("_apply_menu_hotspots", main)

func _cleanup_subarea_nodes(main: Control) -> void:
	for child: Node in main.get_children():
		var node_name: String = str(child.name)
		if node_name.begins_with("SubareaEntry_") or node_name.begins_with("SubareaHotspot_"):
			child.queue_free()

func _apply_interaction_lock(main: Control) -> void:
	var overlay_blocked: bool = _has_overlay_block(main)
	var movement_blocked: bool = overlay_blocked or DialogueUI.is_open()

	FloorInputFix.set_process_input(not movement_blocked)
	PlayerController.set_process_unhandled_input(not movement_blocked)
	if GameState.run_active:
		PlayerController.set_process(not movement_blocked)
	else:
		PlayerController.set_process(true)

	if DialogueUI.layer != null and is_instance_valid(DialogueUI.layer):
		DialogueUI.layer.visible = not overlay_blocked
	if DialogueUI.speech_layer != null and is_instance_valid(DialogueUI.speech_layer):
		DialogueUI.speech_layer.visible = not overlay_blocked

func _has_overlay_block(main: Control) -> bool:
	if MenuUI.overlay_layer != null:
		return true
	if UIPolish.pause_layer != null or UIPolish.inventory_layer != null:
		return true
	if AchievementsUI.overlay_layer != null:
		return true
	var modal_value: Variant = main.get("modal_layer")
	if modal_value is Control:
		var modal: Control = modal_value as Control
		if modal != null and is_instance_valid(modal):
			return true
	return false
