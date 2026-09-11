extends Node

signal transition_started(kind: String, target_area: String)
signal transition_finished(kind: String, target_area: String)

const PIZZA_ICON_PATH: String = "res://assets/ui/icons/pizza.png"
const MENU_TEXTURE_PATH: String = "res://assets/scenarios/menu.png"
const SUBAREA_IDS: Array[String] = [
	"reception_waiting_room",
	"reception_auditorium",
	"innovation_meeting_room",
	"ti_server_room",
	"ti_service_desk",
	"rh_time_control",
	"rh_third_party_registration",
	"documentation_archive_reprography"
]

const AREA_FADE_OUT: float = 0.18
const AREA_FADE_IN: float = 0.18
const SUBAREA_FADE_OUT: float = 0.10
const SUBAREA_FADE_IN: float = 0.12
const DARK_ALPHA: float = 0.94

var overlay_layer: CanvasLayer = null
var shade: ColorRect = null
var pizza_icon: TextureRect = null
var _busy: bool = false
var _target_area: String = ""

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	process_priority = 500

func is_transitioning() -> bool:
	return _busy

func transition_to(area_id: String, commit_callback: Callable) -> void:
	if area_id.is_empty() or not commit_callback.is_valid():
		return
	if _busy:
		return
	var current_area: String = str(GameState.current_area)
	# Mesmo quando GameState já aponta para a Recepção, saindo do menu principal
	# ainda queremos a animação de entrada no jogo.
	if current_area == area_id and not _main_menu_is_visible():
		commit_callback.call(area_id)
		return
	var kind: String = "subarea" if _is_subarea_transition(current_area, area_id) else "area"
	_run_transition(area_id, commit_callback, kind)

func _run_transition(area_id: String, commit_callback: Callable, kind: String) -> void:
	_busy = true
	_target_area = area_id
	_ensure_overlay()
	_fit_overlay_to_viewport()
	_set_blocking(true)
	transition_started.emit(kind, area_id)

	var fade_out: float = SUBAREA_FADE_OUT if kind == "subarea" else AREA_FADE_OUT
	var fade_in: float = SUBAREA_FADE_IN if kind == "subarea" else AREA_FADE_IN
	var show_pizza: bool = kind == "area"

	if shade != null:
		shade.visible = true
		shade.color = Color(0.01, 0.015, 0.02, DARK_ALPHA)
		shade.modulate.a = 0.0
	if pizza_icon != null:
		pizza_icon.visible = show_pizza
		pizza_icon.modulate.a = 0.0
		pizza_icon.rotation = -0.10
		pizza_icon.scale = Vector2(0.86, 0.86)

	var tween_out: Tween = create_tween()
	tween_out.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween_out.set_parallel(true)
	if shade != null:
		tween_out.tween_property(shade, "modulate:a", 1.0, fade_out).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	if show_pizza and pizza_icon != null:
		tween_out.tween_property(pizza_icon, "modulate:a", 1.0, fade_out * 0.82)
		tween_out.tween_property(pizza_icon, "rotation", 0.10, fade_out)
		tween_out.tween_property(pizza_icon, "scale", Vector2(1.0, 1.0), fade_out).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	await tween_out.finished

	if commit_callback.is_valid():
		commit_callback.call(area_id)
	await get_tree().process_frame
	_fit_overlay_to_viewport()

	var tween_in: Tween = create_tween()
	tween_in.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween_in.set_parallel(true)
	if shade != null:
		tween_in.tween_property(shade, "modulate:a", 0.0, fade_in).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	if show_pizza and pizza_icon != null:
		tween_in.tween_property(pizza_icon, "modulate:a", 0.0, fade_in * 0.72)
		tween_in.tween_property(pizza_icon, "rotation", 0.22, fade_in)
		tween_in.tween_property(pizza_icon, "scale", Vector2(1.08, 1.08), fade_in)
	await tween_in.finished

	_set_blocking(false)
	if shade != null:
		shade.visible = false
	if pizza_icon != null:
		pizza_icon.visible = false
	_busy = false
	_target_area = ""
	transition_finished.emit(kind, area_id)

func _ensure_overlay() -> void:
	if overlay_layer != null and is_instance_valid(overlay_layer):
		return
	overlay_layer = CanvasLayer.new()
	overlay_layer.name = "SceneTransitionLayer"
	overlay_layer.layer = 1900
	add_child(overlay_layer)

	shade = ColorRect.new()
	shade.name = "TransitionShade"
	shade.color = Color(0.01, 0.015, 0.02, DARK_ALPHA)
	shade.modulate.a = 0.0
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	overlay_layer.add_child(shade)

	if ResourceLoader.exists(PIZZA_ICON_PATH):
		var resource: Resource = load(PIZZA_ICON_PATH)
		if resource is Texture2D:
			pizza_icon = TextureRect.new()
			pizza_icon.name = "TransitionPizza"
			pizza_icon.texture = resource as Texture2D
			pizza_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			pizza_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			pizza_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
			pizza_icon.modulate.a = 0.0
			pizza_icon.visible = false
			overlay_layer.add_child(pizza_icon)
	_fit_overlay_to_viewport()

func _fit_overlay_to_viewport() -> void:
	var view_size: Vector2 = get_viewport().get_visible_rect().size
	if shade != null:
		shade.position = Vector2.ZERO
		shade.size = view_size
	if pizza_icon != null:
		var icon_size: Vector2 = Vector2(68.0, 68.0)
		pizza_icon.size = icon_size
		pizza_icon.position = (view_size - icon_size) * 0.5
		pizza_icon.pivot_offset = icon_size * 0.5

func _set_blocking(enabled: bool) -> void:
	if shade != null:
		shade.mouse_filter = Control.MOUSE_FILTER_STOP if enabled else Control.MOUSE_FILTER_IGNORE

func _is_subarea_transition(from_area: String, to_area: String) -> bool:
	return from_area in SUBAREA_IDS or to_area in SUBAREA_IDS

func _main_menu_is_visible() -> bool:
	var current: Node = get_tree().current_scene
	if not (current is Control):
		return false
	for child: Node in current.get_children():
		if child is TextureRect:
			var background: TextureRect = child as TextureRect
			if background.texture != null and background.texture.resource_path == MENU_TEXTURE_PATH:
				return true
	return false
