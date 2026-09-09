extends Node

const SHEET_PATH: String = "res://assets/characters/protagonist_movement.png"
const CELL_SIZE: Vector2i = Vector2i(192, 320)
const WALK_SPEED: float = 430.0
const ARRIVAL_DISTANCE: float = 9.0

var _main: Control = null
var _player_root: Node2D = null
var _sprite: AnimatedSprite2D = null
var _frames: SpriteFrames = null
var _current_area: String = ""
var _image_position: Vector2 = Vector2(836, 790)
var _target_image_position: Vector2 = Vector2(836, 790)
var _moving: bool = false
var _last_direction: String = "down"
var _pending_callback: Callable = Callable()

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_process(true)

func _process(delta: float) -> void:
	if not GameState.run_active:
		_hide_player()
		return
	_main = _get_main()
	if _main == null:
		return
	var bg: TextureRect = _find_background(_main)
	if bg == null or bg.texture == null:
		return
	_ensure_player(_main)
	_handle_area_change(bg)
	_patch_hotspot_buttons(_main)
	_update_movement(delta, bg)
	_update_screen_transform(bg)

func _unhandled_input(event: InputEvent) -> void:
	if not GameState.run_active:
		return
	var mouse_event: InputEventMouseButton = event as InputEventMouseButton
	if mouse_event == null or not mouse_event.pressed or mouse_event.button_index != MOUSE_BUTTON_LEFT:
		return
	var main: Control = _get_main()
	if main == null:
		return
	var bg: TextureRect = _find_background(main)
	if bg == null or bg.texture == null:
		return
	var image_point: Vector2 = _screen_to_image(bg, mouse_event.position)
	var source_size: Vector2 = Vector2(bg.texture.get_size())
	var full_rect: Rect2 = Rect2(Vector2.ZERO, source_size)
	if not full_rect.has_point(image_point):
		return
	_pending_callback = Callable()
	_move_to(_clamp_walkable(image_point, source_size))

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

func _ensure_player(main: Control) -> void:
	if _player_root != null and is_instance_valid(_player_root) and _player_root.get_parent() == main:
		_player_root.visible = true
		return
	_player_root = Node2D.new()
	_player_root.name = "PointAndClickPlayer"
	main.add_child(_player_root)
	main.move_child(_player_root, mini(1, main.get_child_count() - 1))
	_sprite = AnimatedSprite2D.new()
	_sprite.name = "AnimatedSprite2D"
	_sprite.centered = true
	_sprite.position = Vector2(0, -float(CELL_SIZE.y) * 0.5)
	_player_root.add_child(_sprite)
	_build_frames()
	if _frames != null:
		_sprite.sprite_frames = _frames
		_play_idle()

func _build_frames() -> void:
	if _frames != null:
		return
	if not ResourceLoader.exists(SHEET_PATH):
		return
	var texture_resource: Resource = load(SHEET_PATH)
	var texture: Texture2D = texture_resource as Texture2D
	if texture == null:
		return
	_frames = SpriteFrames.new()
	_add_idle_animation(texture, "idle_down", 0)
	_add_idle_animation(texture, "idle_up", 1)
	_add_idle_animation(texture, "idle_left", 2)
	_add_idle_animation(texture, "idle_right", 3)
	_add_walk_animation(texture, "walk_down", 1)
	_add_walk_animation(texture, "walk_up", 2)
	_add_walk_animation(texture, "walk_left", 3)
	_add_walk_animation(texture, "walk_right", 4)

func _add_idle_animation(texture: Texture2D, animation_name: String, column: int) -> void:
	_frames.add_animation(animation_name)
	_frames.set_animation_loop(animation_name, true)
	_frames.set_animation_speed(animation_name, 1.0)
	_frames.add_frame(animation_name, _atlas_frame(texture, column, 0))

func _add_walk_animation(texture: Texture2D, animation_name: String, row: int) -> void:
	_frames.add_animation(animation_name)
	_frames.set_animation_loop(animation_name, true)
	_frames.set_animation_speed(animation_name, 8.0)
	for column: int in range(4):
		_frames.add_frame(animation_name, _atlas_frame(texture, column, row))

func _atlas_frame(texture: Texture2D, column: int, row: int) -> AtlasTexture:
	var atlas: AtlasTexture = AtlasTexture.new()
	atlas.atlas = texture
	atlas.region = Rect2(
		Vector2(float(column * CELL_SIZE.x), float(row * CELL_SIZE.y)),
		Vector2(float(CELL_SIZE.x), float(CELL_SIZE.y))
	)
	return atlas

func _handle_area_change(bg: TextureRect) -> void:
	var area: String = GameState.current_area
	if area == _current_area:
		return
	_current_area = area
	var source_size: Vector2 = Vector2(bg.texture.get_size())
	_image_position = _spawn_for_area(area, source_size)
	_target_image_position = _image_position
	_moving = false
	_pending_callback = Callable()
	_last_direction = "up" if area != "reception" else "up"
	_play_idle()

func _spawn_for_area(area: String, source_size: Vector2) -> Vector2:
	var spawns: Dictionary = {
		"reception": Vector2(830, 820),
		"reception_waiting_room": Vector2(835, 820),
		"reception_auditorium": Vector2(1370, 790),
		"innovation": Vector2(180, 780),
		"ti": Vector2(180, 790),
		"rh": Vector2(180, 820),
		"documentation": Vector2(180, 850)
	}
	if spawns.has(area):
		return _clamp_walkable(Vector2(spawns[area]), source_size)
	return _clamp_walkable(Vector2(source_size.x * 0.5, source_size.y * 0.84), source_size)

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

func _move_to(point: Vector2) -> void:
	_target_image_position = point
	_moving = _image_position.distance_to(_target_image_position) > ARRIVAL_DISTANCE
	if not _moving:
		_finish_move()

func _update_movement(delta: float, bg: TextureRect) -> void:
	if not _moving:
		return
	var offset: Vector2 = _target_image_position - _image_position
	var distance: float = offset.length()
	if distance <= ARRIVAL_DISTANCE:
		_image_position = _target_image_position
		_finish_move()
		return
	var direction: Vector2 = offset / maxf(distance, 0.001)
	var step: float = minf(WALK_SPEED * delta, distance)
	_image_position += direction * step
	_set_direction_from_vector(direction)
	_play_walk()
	var source_size: Vector2 = Vector2(bg.texture.get_size())
	_image_position = _clamp_walkable(_image_position, source_size)

func _finish_move() -> void:
	_moving = false
	_play_idle()
	if _pending_callback.is_valid():
		var callback: Callable = _pending_callback
		_pending_callback = Callable()
		callback.call_deferred()

func _set_direction_from_vector(direction: Vector2) -> void:
	if absf(direction.x) > absf(direction.y):
		_last_direction = "right" if direction.x > 0.0 else "left"
	else:
		_last_direction = "down" if direction.y > 0.0 else "up"

func _play_walk() -> void:
	if _sprite == null or _frames == null:
		return
	var name: StringName = StringName("walk_" + _last_direction)
	if _sprite.animation != name:
		_sprite.play(name)

func _play_idle() -> void:
	if _sprite == null or _frames == null:
		return
	var name: StringName = StringName("idle_" + _last_direction)
	_sprite.play(name)

func _update_screen_transform(bg: TextureRect) -> void:
	if _player_root == null or not is_instance_valid(_player_root):
		return
	var source_size: Vector2 = Vector2(bg.texture.get_size())
	var sx: float = bg.size.x / maxf(source_size.x, 1.0)
	var sy: float = bg.size.y / maxf(source_size.y, 1.0)
	_player_root.position = bg.position + Vector2(_image_position.x * sx, _image_position.y * sy)
	var bounds: Rect2 = _walk_bounds(source_size)
	var depth: float = inverse_lerp(bounds.position.y, bounds.end.y, _image_position.y)
	var desired_height_in_source: float = lerpf(155.0, 225.0, depth)
	var visual_scale: float = desired_height_in_source / float(CELL_SIZE.y)
	var canvas_scale: float = minf(sx, sy)
	_player_root.scale = Vector2.ONE * visual_scale * canvas_scale

func _screen_to_image(bg: TextureRect, screen_point: Vector2) -> Vector2:
	var source_size: Vector2 = Vector2(bg.texture.get_size())
	if bg.size.x <= 0.0 or bg.size.y <= 0.0:
		return Vector2.ZERO
	var local: Vector2 = screen_point - bg.position
	return Vector2(
		local.x * source_size.x / bg.size.x,
		local.y * source_size.y / bg.size.y
	)

func _patch_hotspot_buttons(main: Control) -> void:
	var nodes: Array[Node] = main.find_children("*", "Button", true, false)
	for node: Node in nodes:
		var button: Button = node as Button
		if button == null:
			continue
		if button.text != "" or button.tooltip_text == "":
			continue
		if button.has_meta("player_walk_wrapped"):
			continue
		var connections: Array = button.get_signal_connection_list("pressed")
		if connections.is_empty():
			continue
		var callbacks: Array[Callable] = []
		for entry_value: Variant in connections:
			var entry: Dictionary = Dictionary(entry_value)
			if not entry.has("callable"):
				continue
			var callback: Callable = entry["callable"]
			if callback.is_valid():
				callbacks.append(callback)
				button.disconnect("pressed", callback)
		if callbacks.is_empty():
			continue
		button.pressed.connect(_hotspot_pressed.bind(button, callbacks))
		button.set_meta("player_walk_wrapped", true)

func _hotspot_pressed(button: Button, callbacks: Array[Callable]) -> void:
	if button == null or not is_instance_valid(button):
		return
	var main: Control = _get_main()
	if main == null:
		return
	var bg: TextureRect = _find_background(main)
	if bg == null or bg.texture == null:
		_call_callbacks(callbacks)
		return
	var approach_screen: Vector2 = button.position + Vector2(button.size.x * 0.5, button.size.y * 0.92)
	var source_size: Vector2 = Vector2(bg.texture.get_size())
	var approach_image: Vector2 = _clamp_walkable(_screen_to_image(bg, approach_screen), source_size)
	_pending_callback = _call_callbacks.bind(callbacks)
	_move_to(approach_image)

func _call_callbacks(callbacks: Array[Callable]) -> void:
	for callback: Callable in callbacks:
		if callback.is_valid():
			callback.call()

func _hide_player() -> void:
	if _player_root != null and is_instance_valid(_player_root):
		_player_root.visible = false
