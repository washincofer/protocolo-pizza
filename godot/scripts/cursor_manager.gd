extends Node

const CURSOR_IDLE_PATH: String = "res://assets/ui/cursor/cursor_idle.png"
const CURSOR_ACTIVE_PATH: String = "res://assets/ui/cursor/cursor_active.png"
const CURSOR_HOTSPOT: Vector2 = Vector2(34.0, 2.0)

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	call_deferred("_install_cursors")

func _install_cursors() -> void:
	var idle_resource: Resource = load(CURSOR_IDLE_PATH)
	if idle_resource is Texture2D:
		Input.set_custom_mouse_cursor(
			idle_resource as Texture2D,
			Input.CURSOR_ARROW,
			CURSOR_HOTSPOT
		)

	var active_resource: Resource = load(CURSOR_ACTIVE_PATH)
	if active_resource is Texture2D:
		Input.set_custom_mouse_cursor(
			active_resource as Texture2D,
			Input.CURSOR_POINTING_HAND,
			CURSOR_HOTSPOT
		)
