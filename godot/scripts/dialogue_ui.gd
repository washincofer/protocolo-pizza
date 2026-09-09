extends Node

signal choice_selected(dialogue_id: String, choice_id: String)

var layer: CanvasLayer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func open_dialogue(dialogue_id: String, speaker: String, text: String, choices: Array) -> void:
	close_dialogue()
	layer = CanvasLayer.new()
	layer.layer = 940
	add_child(layer)

	var shade := ColorRect.new()
	shade.color = Color(0, 0, 0, 0.42)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	layer.add_child(shade)

	var bottom := MarginContainer.new()
	bottom.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	bottom.offset_left = 80
	bottom.offset_right = -80
	bottom.offset_top = -380
	bottom.offset_bottom = -30
	layer.add_child(bottom)

	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", _panel_style())
	bottom.add_child(panel)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 10)
	panel.add_child(box)

	var speaker_label := Label.new()
	speaker_label.text = speaker
	speaker_label.add_theme_font_size_override("font_size", 25)
	speaker_label.add_theme_color_override("font_color", Color("ffd34e"))
	box.add_child(speaker_label)

	var text_label := Label.new()
	text_label.text = text
	text_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	text_label.add_theme_font_size_override("font_size", 20)
	box.add_child(text_label)

	for choice_data in choices:
		var choice := Dictionary(choice_data)
		var button := Button.new()
		button.text = "%s — %s" % [str(choice.get("key", "?")), str(choice.get("text", ""))]
		button.custom_minimum_size = Vector2(0, 48)
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.add_theme_font_size_override("font_size", 18)
		button.pressed.connect(_select.bind(dialogue_id, str(choice.get("id", ""))))
		box.add_child(button)

func close_dialogue() -> void:
	if layer != null:
		layer.queue_free()
		layer = null

func is_open() -> bool:
	return layer != null

func _select(dialogue_id: String, choice_id: String) -> void:
	close_dialogue()
	choice_selected.emit(dialogue_id, choice_id)

func _panel_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.025, 0.05, 0.08, 0.96)
	style.border_color = Color(1.0, 0.78, 0.18, 0.9)
	style.set_border_width_all(2)
	style.corner_radius_top_left = 18
	style.corner_radius_top_right = 18
	style.corner_radius_bottom_left = 18
	style.corner_radius_bottom_right = 18
	style.content_margin_left = 24
	style.content_margin_right = 24
	style.content_margin_top = 20
	style.content_margin_bottom = 20
	return style
