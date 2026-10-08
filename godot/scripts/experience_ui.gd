extends Node
var overlay_layer: CanvasLayer = null
var status_label: Label = null
var hint_levels: Dictionary = {}
var _background_rect: Rect2 = Rect2()
const Hotspots = preload("res://scripts/hotspot_catalog.gd")
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	GameState.changed.connect(_refresh_status)
	SettingsManager.settings_changed.connect(_refresh_status)
func is_open() -> bool:
	return overlay_layer != null
func attach(main: Control) -> void:
	status_label = Label.new()
	status_label.name = "ProtocolStatus"
	status_label.position = Vector2(18,76)
	status_label.size = Vector2(650,100)
	status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	status_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	status_label.add_theme_font_size_override("font_size",SettingsManager.font_size(16))
	status_label.add_theme_color_override("font_shadow_color",Color.BLACK)
	status_label.add_theme_constant_override("shadow_offset_x",2)
	status_label.add_theme_constant_override("shadow_offset_y",2)
	main.add_child(status_label)
	var view: Vector2 = main.get_viewport_rect().size
	var index: int = 0
	for entry: Array in [["Diário [D]",open_journal],["Dica",show_hint],["Cancelar item",cancel_item]]:
		var b: Button = Button.new()
		b.text = entry[0]
		b.position = Vector2(view.x - 438 + index * 103,12)
		b.size = Vector2(98,42)
		b.add_theme_font_size_override("font_size",SettingsManager.font_size(13))
		b.pressed.connect(entry[1])
		main.add_child(b)
		index += 1
	for hs: Dictionary in Hotspots.get_hotspots(GameState.current_area):
		if str(hs["action"]).ends_with("_back") or hs["action"] in ["legal_phone","ti_systems_entry"]:
			var label: Label = Label.new()
			label.text = "Telefone" if hs["action"] == "legal_phone" else ("Sistemas" if hs["action"] == "ti_systems_entry" else "← Voltar")
			label.set_meta("source_point",Vector2(hs["rect"][0],hs["rect"][1]))
			label.add_theme_font_size_override("font_size",SettingsManager.font_size(14))
			label.add_theme_color_override("font_shadow_color",Color.BLACK)
			label.add_theme_constant_override("shadow_offset_x",2)
			label.add_theme_constant_override("shadow_offset_y",2)
			label.mouse_filter = Control.MOUSE_FILTER_IGNORE
			main.add_child(label)
	_background_rect = Rect2()
	_refresh_status()
func _process(_delta: float) -> void:
	var main: Control = get_tree().current_scene as Control
	if main == null or not GameState.run_active: return
	var bg: TextureRect = null
	for child: Node in main.get_children():
		if child is TextureRect and child.texture != null:
			bg = child
			break
	if bg == null: return
	var rect: Rect2 = Rect2(bg.position,bg.size)
	if rect == _background_rect: return
	_background_rect = rect
	for child: Node in main.get_children():
		if child is Label and child.has_meta("source_point"):
			child.position = bg.position + child.get_meta("source_point") * bg.size / Vector2(bg.texture.get_size())
func objective() -> String:
	match GameState.current_area:
		"reception","reception_waiting_room": return "Identifique a entrega na Recepção; apresente o crachá à Segurança e use as escadas."
		"reception_auditorium": return "Descubra quem Lúcia espera. Você pode voltar à Recepção."
		"innovation","innovation_meeting_room": return "Leve os Óculos VR para Rogério na TI."
		"ti","ti_server_room","ti_service_desk","ti_systems_room": return "Use o VR em Rogério. Depois, siga para Comunicação."
		"communication": return "Descubra o CC-0001 e obtenha o Carimbo de Prioridade Executiva."
		"supplies": return "Apresente a prioridade e o centro de custo a Stan."
		"hall": return "Reúna documentos no Financeiro e kit técnico na Engenharia; depois suba."
		"finance": return "Bruno emite o comprovante; a Pasta de Reembolso leva à exceção fiscal."
		"engineering": return "Pegue o Colete e examine seu bolso para obter a OS."
		"security": return "Vista o Colete e apresente a OS à Sônia."
		"rh","rh_time_control","rh_third_party_registration": return "Ficha → ponto digital → paralelo → validação → Helena. Aqueça a pizza antes de sair."
		"documentation","documentation_archive_reprography": return "Pegue a Bolota pendente e siga para o Jurídico."
		"legal": return "Confira os cinco requisitos no Diário; apresente a Bolota na mesa de análise."
		"directorate": return "Informe o nome do diretor à Carla e entre no gabinete."
	return "Entregue a pizza para Ronaldo Gilberto."
func _refresh_status() -> void:
	if not is_instance_valid(status_label): return
	var main: Node = get_tree().current_scene
	var selected: String = str(main.get("selected_item")) if main != null else ""
	if not selected.is_empty() and not GameState.has_item(selected):
		main.set("selected_item", "")
		selected = ""
	status_label.text = "Objetivo: " + objective()
	if not selected.is_empty(): status_label.text += "\nSelecionado: " + MenuUI._item_name(selected) + " · clique direito para cancelar"
	if GameState.disguise == "maintenance": status_label.text += "\nDisfarce: Manutenção"
	status_label.add_theme_font_size_override("font_size",SettingsManager.font_size(16))
func cancel_item() -> void:
	if InteractionGuard.modal_blocked(): return
	var main: Node = get_tree().current_scene
	if main != null: main.set("selected_item", "")
	_refresh_status()
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		cancel_item()
		get_viewport().set_input_as_handled()
func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_D and not DialogueUI.is_open():
		if is_open(): close()
		else: open_journal()
		get_viewport().set_input_as_handled()
func legal_requirements() -> Array:
	return [["Chamado 48271",GameState.has_flag("legal_ticket")],["Bolota",GameState.has_item("legal_bolota_pending") or GameState.has_item("legal_bolota_approved")],["Assinatura RH",GameState.has_item("rh_validation_signature")],["Protocolo fiscal",GameState.has_item("fiscal_exception_protocol")],["Autorização externa",GameState.has_flag("external_authorization")]]
func open_journal() -> void:
	if InteractionGuard.world_blocked(): return
	overlay_layer = CanvasLayer.new()
	overlay_layer.layer = 2100
	add_child(overlay_layer)
	var shade: ColorRect = ColorRect.new()
	shade.color = Color(0,0,0,0.9)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay_layer.add_child(shade)
	var view: Vector2 = get_viewport().get_visible_rect().size
	var panel: PanelContainer = PanelContainer.new()
	panel.position = Vector2(80,50)
	panel.size = view - Vector2(160,100)
	shade.add_child(panel)
	var box: VBoxContainer = VBoxContainer.new()
	panel.add_child(box)
	var title: Label = Label.new()
	title.text = "DIÁRIO DO PROTOCOLO"
	title.add_theme_font_size_override("font_size",SettingsManager.font_size(24))
	box.add_child(title)
	var scroll: ScrollContainer = ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	box.add_child(scroll)
	var text: Label = Label.new()
	text.custom_minimum_size = Vector2(maxf(250,view.x-190),0)
	text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	text.add_theme_font_size_override("font_size",SettingsManager.font_size(17))
	text.text = "Objetivo: " + objective() + "\n\nRH:\n"
	for entry: Array in [["Ponto digital",GameState.has_flag("point_digital")],["Ponto paralelo",GameState.has_flag("point_parallel")],["Validação de terceiro",GameState.has_flag("third_party_validated")]]:
		text.text += ("✓ " if entry[1] else "○ ") + entry[0] + "\n"
	text.text += "\nJurídico:\n"
	for entry: Array in legal_requirements(): text.text += ("✓ " if entry[1] else "○ ") + entry[0] + "\n"
	text.text += "\nConhecimentos:\n"
	for info: String in GameState.knowledge:
		text.text += {"director_name:ronaldo_gilberto":"Diretor: Ronaldo Gilberto","cc_0001":"CC-0001: Centro de custo da Diretoria","ticket:48271":"Chamado 48271","external_authorization":"Autorização externa recebida"}.get(info,info) + "\n"
	text.text += "\nMapa: Recepção → Inovação → TI → Comunicação → Suprimentos → Hall\nHall → Financeiro / Engenharia → Vigilância → RH → Documentação → Jurídico → Diretoria\n\nHistórico:\n"
	for entry: Dictionary in GameState.dialogue_history: text.text += entry["speaker"] + ": " + entry["text"] + "\n\n"
	scroll.add_child(text)
	var close_button: Button = Button.new()
	close_button.text = "Fechar [ESC/D]"
	close_button.pressed.connect(close)
	box.add_child(close_button)
	close_button.grab_focus()
func close() -> void:
	if overlay_layer != null:
		overlay_layer.queue_free()
		overlay_layer = null
func show_hint() -> void:
	if InteractionGuard.world_blocked(): return
	var area: String = GameState.current_area
	var level: int = mini(int(hint_levels.get(area,0)),2)
	hint_levels[area] = level+1
	var hints: Array = ["Observe a regra que está bloqueando a entrega.","Confira o inventário e os requisitos do Diário.",objective()]
	DialogueUI.show_speech("Dica %d/3" % (level+1),hints[level])
