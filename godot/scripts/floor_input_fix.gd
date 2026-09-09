extends Node

# Captura o clique livre no cenário antes que o Control raiz o consuma.
# Hotspots e demais elementos de UI continuam com prioridade.

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event: InputEvent) -> void:
	if not GameState.run_active:
		return
	var mouse_event: InputEventMouseButton = event as InputEventMouseButton
	if mouse_event == null or not mouse_event.pressed or mouse_event.button_index != MOUSE_BUTTON_LEFT:
		return

	var main: Control = _get_main()
	if main == null:
		return

	# Se o mouse está sobre qualquer Control interativo além do Control raiz,
	# deixa a UI/hotspot cuidar do clique.
	var hovered: Control = get_viewport().gui_get_hovered_control()
	if hovered != null and hovered != main:
		return

	var bg: TextureRect = _find_background(main)
	if bg == null or bg.texture == null:
		return

	var image_point: Vector2 = _screen_to_image(bg, mouse_event.position)
	var source_size: Vector2 = Vector2(bg.texture.get_size())
	var full_rect: Rect2 = Rect2(Vector2.ZERO, source_size)
	if not full_rect.has_point(image_point):
		return

	var target: Vector2 = _clamp_walkable(image_point, source_size)
	PlayerController.set("_pending_callback", Callable())
	PlayerController.call("_move_to", target)

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

func _screen_to_image(bg: TextureRect, screen_point: Vector2) -> Vector2:
	var source_size: Vector2 = Vector2(bg.texture.get_size())
	if bg.size.x <= 0.0 or bg.size.y <= 0.0:
		return Vector2.ZERO
	var local: Vector2 = screen_point - bg.position
	return Vector2(
		local.x * source_size.x / bg.size.x,
		local.y * source_size.y / bg.size.y
	)

func _walk_bounds(source_size: Vector2) -> Rect2:
	return Rect2(
		Vector2(source_size.x * 0.07, source_size.y * 0.56),
		Vector2(source_size.x * 0.86, source_size.y * 0.35)
	)

func _clamp_walkable(point: Vector2, source_size: Vector2) -> Vector2:
	var bounds: Rect2 = _walk_bounds(source_size)
	return Vector2(
		clampf(point.x, bounds.position.x, bounds.end.x),
		clampf(point.y, bounds.position.y, bounds.end.y)
	)
