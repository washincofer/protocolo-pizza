extends Node

const HotspotCatalog = preload("res://scripts/hotspot_catalog.gd")
const SAFE_MARGIN: float = 28.0

var hud_visible: bool = true
var hotspot_debug_visible: bool = true
var coords_visible: bool = false

var coord_layer: CanvasLayer
var coord_panel: PanelContainer
var coord_label: Label
var hotspot_style_visible: StyleBoxFlat
var hotspot_style_hidden: StyleBoxFlat

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_build_styles()
	_build_coordinate_overlay()
	set_process(true)

func _build_styles() -> void:
	hotspot_style_visible = StyleBoxFlat.new()
	hotspot_style_visible.bg_color = Color(1.0, 0.82, 0.2, 0.08)
	hotspot_style_visible.border_color = Color(1.0, 0.82, 0.2, 0.78)
	hotspot_style_visible.set_border_width_all(2)
	hotspot_style_visible.corner_radius_top_left = 8
	hotspot_style_visible.corner_radius_top_right = 8
	hotspot_style_visible.corner_radius_bottom_left = 8
	hotspot_style_visible.corner_radius_bottom_right = 8

	hotspot_style_hidden = StyleBoxFlat.new()
	hotspot_style_hidden.bg_color = Color(1, 1, 1, 0.0)
	hotspot_style_hidden.border_color = Color(1, 1, 1, 0.0)
	hotspot_style_hidden.set_border_width_all(0)

func _build_coordinate_overlay() -> void:
	coord_layer = CanvasLayer.new()
	coord_layer.layer = 1000
	add_child(coord_layer)

	coord_panel = PanelContainer.new()
	coord_panel.position = Vector2(12, 78)
	coord_panel.custom_minimum_size = Vector2(340, 82)
	coord_panel.visible = false
	coord_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	coord_layer.add_child(coord_panel)

	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = Color(0.02, 0.04, 0.07, 0.90)
	style.border_color = Color(0.2, 0.9, 1.0, 0.9)
	style.set_border_width_all(2)
	style.corner_radius_top_left = 10
	style.corner_radius_top_right = 10
	style.corner_radius_bottom_left = 10
	style.corner_radius_bottom_right = 10
	coord_panel.add_theme_stylebox_override("panel", style)

	coord_label = Label.new()
	coord_label.text = "F1 HUD | F2 HOTSPOTS | F3 XY"
	coord_label.add_theme_font_size_override("font_size", 16)
	coord_label.add_theme_color_override("font_color", Color("d7f7ff"))
	coord_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	coord_panel.add_child(coord_label)

func _unhandled_key_input(event: InputEvent) -> void:
	var key_event: InputEventKey = event as InputEventKey
	if key_event == null or not key_event.pressed or key_event.echo:
		return

	match key_event.keycode:
		KEY_F1:
			if GameState.run_active:
				hud_visible = not hud_visible
				_apply_hud_visibility()
			get_viewport().set_input_as_handled()
		KEY_F2:
			if GameState.run_active:
				hotspot_debug_visible = not hotspot_debug_visible
				_apply_hotspot_debug()
			get_viewport().set_input_as_handled()
		KEY_F3:
			coords_visible = not coords_visible
			coord_panel.visible = coords_visible
			get_viewport().set_input_as_handled()

func _process(_delta: float) -> void:
	_apply_safe_fit()
	if GameState.run_active:
		_snap_calibrated_hotspots()
		_apply_hud_visibility()
		_apply_hotspot_debug()
	if coords_visible:
		_update_coordinates()

func _get_main() -> Control:
	var current: Node = get_tree().current_scene
	if current is Control:
		return current as Control
	return null

func _find_background(main: Control) -> TextureRect:
	for child: Node in main.get_children():
		if child is TextureRect:
			var rect: TextureRect = child as TextureRect
			if rect.texture != null:
				return rect
	return null

func _is_hotspot(node: Node) -> bool:
	if not (node is Button):
		return false
	var button: Button = node as Button
	return button.text == "" and button.tooltip_text != ""

func _apply_safe_fit() -> void:
	var main: Control = _get_main()
	if main == null:
		return
	var bg: TextureRect = _find_background(main)
	if bg == null or bg.texture == null:
		return

	var source_size: Vector2 = Vector2(bg.texture.get_size())
	if source_size.x <= 0.0 or source_size.y <= 0.0:
		return
	var view_size: Vector2 = get_viewport().get_visible_rect().size
	var available: Vector2 = Vector2(
		maxf(1.0, view_size.x - SAFE_MARGIN * 2.0),
		maxf(1.0, view_size.y - SAFE_MARGIN * 2.0)
	)
	var new_scale: float = minf(available.x / source_size.x, available.y / source_size.y)
	new_scale = minf(new_scale, 1.0)
	var new_size: Vector2 = source_size * new_scale
	var new_origin: Vector2 = (view_size - new_size) * 0.5

	var old_size: Vector2 = bg.size
	var old_origin: Vector2 = bg.position
	if old_size.x <= 0.0 or old_size.y <= 0.0:
		return
	var old_scale_x: float = old_size.x / source_size.x
	var old_scale_y: float = old_size.y / source_size.y
	if old_scale_x <= 0.0 or old_scale_y <= 0.0:
		return

	if old_origin.distance_to(new_origin) < 0.25 and old_size.distance_to(new_size) < 0.25:
		return

	for child: Node in main.get_children():
		if _is_hotspot(child):
			var button: Button = child as Button
			var source_pos: Vector2 = Vector2(
				(button.position.x - old_origin.x) / old_scale_x,
				(button.position.y - old_origin.y) / old_scale_y
			)
			var source_button_size: Vector2 = Vector2(
				button.size.x / old_scale_x,
				button.size.y / old_scale_y
			)
			button.position = new_origin + source_pos * new_scale
			button.size = source_button_size * new_scale

	bg.position = new_origin
	bg.size = new_size

func _snap_calibrated_hotspots() -> void:
	var main: Control = _get_main()
	if main == null:
		return
	var bg: TextureRect = _find_background(main)
	if bg == null or bg.texture == null or bg.size.x <= 0.0 or bg.size.y <= 0.0:
		return

	var area_id: String = GameState.current_area
	var entries: Array = HotspotCatalog.get_hotspots(area_id)
	if entries.is_empty():
		return

	var source_size: Vector2 = Vector2(bg.texture.get_size())
	if source_size.x <= 0.0 or source_size.y <= 0.0:
		return
	var sx: float = bg.size.x / source_size.x
	var sy: float = bg.size.y / source_size.y

	var calibrated: Dictionary = {}
	for value: Variant in entries:
		var data: Dictionary = Dictionary(value)
		if not data.has("bounds"):
			continue
		var bounds: Array = Array(data.get("bounds", []))
		if bounds.size() < 4:
			continue
		var x1: float = float(bounds[0])
		var y1: float = float(bounds[1])
		var x2: float = float(bounds[2])
		var y2: float = float(bounds[3])
		var left: float = minf(x1, x2)
		var top: float = minf(y1, y2)
		var right: float = maxf(x1, x2)
		var bottom: float = maxf(y1, y2)
		calibrated[str(data.get("label", ""))] = Rect2(left, top, right - left, bottom - top)

	if calibrated.is_empty():
		return

	for child: Node in main.get_children():
		if not _is_hotspot(child):
			continue
		var button: Button = child as Button
		if not calibrated.has(button.tooltip_text):
			continue
		var source_rect: Rect2 = calibrated[button.tooltip_text]
		button.position = bg.position + Vector2(source_rect.position.x * sx, source_rect.position.y * sy)
		button.size = Vector2(source_rect.size.x * sx, source_rect.size.y * sy)

func _apply_hud_visibility() -> void:
	var main: Control = _get_main()
	if main == null:
		return
	var view_height: float = get_viewport().get_visible_rect().size.y
	for child: Node in main.get_children():
		if child is Button:
			var button: Button = child as Button
			if button.text == "☰":
				button.visible = hud_visible
		elif child is PanelContainer:
			var panel: PanelContainer = child as PanelContainer
			var is_top_hud: bool = panel.position.y <= 24.0 and panel.size.y <= 100.0
			var is_bottom_hud: bool = panel.position.y >= view_height - 180.0
			if is_top_hud or is_bottom_hud:
				panel.visible = hud_visible

func _apply_hotspot_debug() -> void:
	var main: Control = _get_main()
	if main == null:
		return
	for child: Node in main.get_children():
		if _is_hotspot(child):
			var button: Button = child as Button
			button.add_theme_stylebox_override(
				"normal",
				hotspot_style_visible if hotspot_debug_visible else hotspot_style_hidden
			)

func _update_coordinates() -> void:
	var main: Control = _get_main()
	if main == null:
		coord_label.text = "F1 HUD | F2 HOTSPOTS | F3 XY\nSem cena ativa"
		return
	var bg: TextureRect = _find_background(main)
	if bg == null or bg.texture == null:
		coord_label.text = "F1 HUD | F2 HOTSPOTS | F3 XY\nSem imagem ativa"
		return

	var mouse: Vector2 = get_viewport().get_mouse_position()
	var source_size: Vector2 = Vector2(bg.texture.get_size())
	var local: Vector2 = mouse - bg.position
	var inside: bool = local.x >= 0.0 and local.y >= 0.0 and local.x <= bg.size.x and local.y <= bg.size.y
	var image_pos: Vector2 = Vector2(-1, -1)
	if bg.size.x > 0.0 and bg.size.y > 0.0:
		image_pos = Vector2(
			local.x * source_size.x / bg.size.x,
			local.y * source_size.y / bg.size.y
		)

	var state_text: String = "HUD %s | HOTSPOTS %s" % [
		"ON" if hud_visible else "OFF",
		"ON" if hotspot_debug_visible else "OFF"
	]
	if inside:
		coord_label.text = "F1 HUD | F2 HOTSPOTS | F3 XY\n%s\nTela X:%d Y:%d | Imagem X:%d Y:%d" % [
			state_text,
			int(round(mouse.x)), int(round(mouse.y)),
			int(round(image_pos.x)), int(round(image_pos.y))
		]
	else:
		coord_label.text = "F1 HUD | F2 HOTSPOTS | F3 XY\n%s\nTela X:%d Y:%d | fora da imagem" % [
			state_text,
			int(round(mouse.x)), int(round(mouse.y))
		]
