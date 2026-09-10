extends Node

const ITEM_TEXTURE_PREFIX: String = "res://assets/ui/items/"
const SAFE_PREVIEW_NAME: StringName = &"InventorySafePreview"

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	process_priority = 240
	set_process(true)

func _process(_delta: float) -> void:
	var menu_ui: Node = get_node_or_null("/root/MenuUI")
	if menu_ui == null:
		return
	var overlay_value: Variant = menu_ui.get("overlay_layer")
	if not (overlay_value is CanvasLayer):
		return
	var overlay: CanvasLayer = overlay_value as CanvasLayer
	var root_node: Node = overlay.get_node_or_null("MenuUIScreen_inventory")
	if not (root_node is Control):
		return
	var root: Control = root_node as Control
	root.clip_contents = true

	var source_preview: TextureRect = _find_source_preview(root)
	if source_preview == null:
		return

	# A textura original da descrição ficava livre para escapar do painel em alguns builds Web.
	# Mantemos o nó original invisível e desenhamos uma cópia rigidamente limitada à caixa 78x78.
	source_preview.visible = false
	var safe_preview: Button = root.get_node_or_null(SAFE_PREVIEW_NAME) as Button
	if safe_preview == null:
		safe_preview = Button.new()
		safe_preview.name = SAFE_PREVIEW_NAME
		safe_preview.text = ""
		safe_preview.position = Vector2(45.0, 450.0)
		safe_preview.size = Vector2(78.0, 78.0)
		safe_preview.focus_mode = Control.FOCUS_NONE
		safe_preview.mouse_filter = Control.MOUSE_FILTER_IGNORE
		safe_preview.expand_icon = true
		safe_preview.icon_max_width = 68
		var empty_style: StyleBoxEmpty = StyleBoxEmpty.new()
		safe_preview.add_theme_stylebox_override("normal", empty_style)
		safe_preview.add_theme_stylebox_override("hover", empty_style)
		safe_preview.add_theme_stylebox_override("pressed", empty_style)
		safe_preview.add_theme_stylebox_override("disabled", empty_style)
		root.add_child(safe_preview)
	safe_preview.icon = source_preview.texture

func _find_source_preview(root: Control) -> TextureRect:
	for child: Node in root.get_children():
		if not (child is TextureRect):
			continue
		var texture_rect: TextureRect = child as TextureRect
		if texture_rect.texture == null:
			continue
		var texture_path: String = texture_rect.texture.resource_path
		if texture_path.begins_with(ITEM_TEXTURE_PREFIX) and texture_rect.position.y >= 400.0:
			return texture_rect
	return null
