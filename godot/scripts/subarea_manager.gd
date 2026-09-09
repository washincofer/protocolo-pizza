extends Node

const SOURCE_SIZE := Vector2(1672, 941)

const SUBAREAS := {
	"reception_waiting_room": {
		"title": "Recepção — Sala de Espera",
		"parent": "reception",
		"background": "res://assets/subareas/reception_waiting_room.webp",
		"hotspots": [
			{"label":"Visitante esperando","rect":[310,300,650,390],"action":"waiting_person"},
			{"label":"Máquina de café","rect":[1280,220,300,520],"action":"waiting_coffee"},
			{"label":"Voltar à Recepção","rect":[0,100,190,700],"action":"return_parent"}
		]
	},
	"reception_auditorium": {
		"title": "Recepção — Auditório / Onboarding",
		"parent": "reception",
		"background": "res://assets/subareas/reception_auditorium.webp",
		"hotspots": [
			{"label":"Lúcia Pauta","rect":[90,250,390,470],"action":"auditorium_lucia"},
			{"label":"Púlpito da apresentação","rect":[540,210,620,470],"action":"auditorium_stage"},
			{"label":"Voltar à Recepção","rect":[1460,100,210,700],"action":"return_parent"}
		]
	},
	"innovation_meeting_room": {
		"title": "Inovação — Sala de Reunião",
		"parent": "innovation",
		"background": "res://assets/subareas/innovation_meeting_room.webp",
		"hotspots": [
			{"label":"Reunião de inovação","rect":[390,180,900,520],"action":"core_innovation_meeting"},
			{"label":"Quadro de ideias","rect":[1030,90,500,360],"action":"innovation_board"},
			{"label":"Voltar à Inovação","rect":[0,100,190,700],"action":"return_parent"}
		]
	},
	"ti_server_room": {
		"title": "TI — Sala de Servidores",
		"parent": "ti",
		"background": "res://assets/subareas/ti_server_room.webp",
		"hotspots": [
			{"label":"Racks de servidores","rect":[180,130,1160,620],"action":"server_racks"},
			{"label":"Painel crítico","rect":[1330,250,270,430],"action":"server_panel"},
			{"label":"Voltar à TI","rect":[0,100,180,700],"action":"return_parent"}
		]
	},
	"ti_service_desk": {
		"title": "TI — Service Desk",
		"parent": "ti",
		"background": "res://assets/subareas/ti_service_desk.webp",
		"hotspots": [
			{"label":"Samir Maxo","rect":[250,260,570,480],"action":"core_ti_service"},
			{"label":"Fila de chamados","rect":[850,180,650,440],"action":"service_queue"},
			{"label":"Voltar à TI","rect":[0,100,180,700],"action":"return_parent"}
		]
	},
	"rh_time_control": {
		"title": "RH — Controle de Ponto",
		"parent": "rh",
		"background": "res://assets/subareas/rh_time_control.webp",
		"hotspots": [
			{"label":"Paulo Pontes","rect":[230,230,520,500],"action":"core_rh_point"},
			{"label":"Controle paralelo","rect":[870,240,620,450],"action":"core_rh_parallel"},
			{"label":"Voltar ao RH","rect":[0,100,180,700],"action":"return_parent"}
		]
	},
	"rh_third_party_registration": {
		"title": "RH — Cadastro de Terceiros",
		"parent": "rh",
		"background": "res://assets/subareas/rh_third_party_registration.webp",
		"hotspots": [
			{"label":"Caio Dastro","rect":[260,220,550,510],"action":"core_rh_validator"},
			{"label":"Formulários de cadastro","rect":[860,250,600,430],"action":"registration_forms"},
			{"label":"Voltar ao RH","rect":[0,100,180,700],"action":"return_parent"}
		]
	},
	"documentation_archive_reprography": {
		"title": "Documentação — Arquivo / Reprografia",
		"parent": "documentation",
		"background": "res://assets/subareas/documentation_archive_reprography.webp",
		"hotspots": [
			{"label":"Domingos Hurley","rect":[220,240,520,500],"action":"archive_domingos"},
			{"label":"Impressora / Scanner","rect":[880,220,600,500],"action":"core_documentation_printer"},
			{"label":"Voltar à Documentação","rect":[0,100,180,700],"action":"return_parent"}
		]
	}
}

const ENTRY_MAP := {
	"reception": {
		"Balcão da Recepção": "dialogue_receptionist",
		"Sofá de Espera": "reception_waiting_room",
		"Totem Primeiro Cadastro": "reception_totem",
		"Auditório": "reception_auditorium"
	},
	"innovation": {
		"Sala de Reunião": "innovation_meeting_room"
	},
	"ti": {
		"Service Desk": "ti_service_desk"
	},
	"rh": {
		"Controle de Ponto": "rh_time_control",
		"Cadastro de Terceiros": "rh_third_party_registration"
	},
	"documentation": {
		"Impressora / Cópias": "documentation_archive_reprography"
	}
}

var _patched_area := ""

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	DialogueUI.choice_selected.connect(_on_dialogue_choice)
	set_process(true)

func _process(_delta: float) -> void:
	if not GameState.run_active:
		return
	var main := _get_main()
	if main == null:
		return
	var area := GameState.current_area
	if SUBAREAS.has(area):
		_apply_subarea(main, area)
	else:
		_apply_entry_overlays(main, area)

func _get_main() -> Control:
	var current := get_tree().current_scene
	if current is Control:
		return current as Control
	return null

func _find_background(main: Control) -> TextureRect:
	for child in main.get_children():
		if child is TextureRect:
			var bg := child as TextureRect
			if bg.texture != null:
				return bg
	return null

func _find_hotspot(main: Control, tooltip: String) -> Button:
	for child in main.get_children():
		if child is Button:
			var button := child as Button
			if button.text == "" and button.tooltip_text == tooltip:
				return button
	return null

func _apply_entry_overlays(main: Control, area: String) -> void:
	if not ENTRY_MAP.has(area):
		return
	var entries := Dictionary(ENTRY_MAP[area])
	for tooltip in entries.keys():
		var original := _find_hotspot(main, str(tooltip))
		if original == null:
			continue
		var node_name := "SubareaEntry_%s" % str(tooltip).replace(" ", "_").replace("/", "_")
		if main.get_node_or_null(node_name) != null:
			continue
		original.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var overlay := _transparent_button(str(tooltip), original.position, original.size)
		overlay.name = node_name
		overlay.z_index = 60
		var target := str(entries[tooltip])
		if target == "dialogue_receptionist":
			overlay.pressed.connect(_open_receptionist_dialogue)
		elif target == "reception_totem":
			overlay.pressed.connect(_open_reception_totem)
		else:
			overlay.pressed.connect(_enter_subarea.bind(target))
		main.add_child(overlay)

	# A sala de servidores ainda não tinha hotspot próprio no cenário principal de TI.
	if area == "ti" and main.get_node_or_null("SubareaEntry_Servidores") == null:
		var bg := _find_background(main)
		if bg != null:
			var rect := _source_rect_to_screen(bg, Rect2(690, 70, 300, 280))
			var server_entry := _transparent_button("Sala de Servidores", rect.position, rect.size)
			server_entry.name = "SubareaEntry_Servidores"
			server_entry.z_index = 60
			server_entry.pressed.connect(_enter_subarea.bind("ti_server_room"))
			main.add_child(server_entry)

func _apply_subarea(main: Control, area: String) -> void:
	var data := Dictionary(SUBAREAS[area])
	var bg := _find_background(main)
	if bg == null:
		return
	var expected_path := str(data.get("background", ""))
	if bg.texture == null or bg.texture.resource_path != expected_path:
		var texture = load(expected_path)
		if texture != null:
			bg.texture = texture

	_update_hud_title(main, area, str(data.get("title", area)))
	for hs_data in Array(data.get("hotspots", [])):
		var hs := Dictionary(hs_data)
		var action := str(hs.get("action", ""))
		var node_name := "SubareaHotspot_%s" % action
		if main.get_node_or_null(node_name) != null:
			continue
		var rect_values := Array(hs.get("rect", [0,0,1,1]))
		var source_rect := Rect2(float(rect_values[0]), float(rect_values[1]), float(rect_values[2]), float(rect_values[3]))
		var screen_rect := _source_rect_to_screen(bg, source_rect)
		var button := _transparent_button(str(hs.get("label", action)), screen_rect.position, screen_rect.size)
		button.name = node_name
		button.z_index = 60
		button.pressed.connect(_handle_subarea_action.bind(area, action))
		main.add_child(button)

func _update_hud_title(main: Control, area: String, friendly_title: String) -> void:
	for node in main.find_children("*", "Label", true, false):
		var label := node as Label
		if label.text == area:
			label.text = friendly_title
			return

func _source_rect_to_screen(bg: TextureRect, source_rect: Rect2) -> Rect2:
	var source_size := Vector2(bg.texture.get_size()) if bg.texture != null else SOURCE_SIZE
	var sx := bg.size.x / maxf(source_size.x, 1.0)
	var sy := bg.size.y / maxf(source_size.y, 1.0)
	return Rect2(
		bg.position + Vector2(source_rect.position.x * sx, source_rect.position.y * sy),
		Vector2(source_rect.size.x * sx, source_rect.size.y * sy)
	)

func _transparent_button(tooltip: String, position: Vector2, size: Vector2) -> Button:
	var button := Button.new()
	button.text = ""
	button.tooltip_text = tooltip
	button.position = position
	button.size = size
	button.focus_mode = Control.FOCUS_NONE
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	var normal := StyleBoxFlat.new()
	normal.bg_color = Color(1, 1, 1, 0)
	normal.border_color = Color(1, 1, 1, 0)
	button.add_theme_stylebox_override("normal", normal)
	var hover := StyleBoxFlat.new()
	hover.bg_color = Color(1.0, 0.82, 0.2, 0.08)
	hover.border_color = Color(1.0, 0.82, 0.2, 0.95)
	hover.set_border_width_all(3)
	hover.corner_radius_top_left = 10
	hover.corner_radius_top_right = 10
	hover.corner_radius_bottom_left = 10
	hover.corner_radius_bottom_right = 10
	button.add_theme_stylebox_override("hover", hover)
	button.add_theme_stylebox_override("pressed", hover)
	return button

func _enter_subarea(area_id: String) -> void:
	SceneRouter.route_to(area_id)

func _handle_subarea_action(area: String, action: String) -> void:
	match action:
		"return_parent":
			var data := Dictionary(SUBAREAS[area])
			SceneRouter.route_to(str(data.get("parent", "reception")))
		"waiting_person":
			var count := int(GameState.flags.get("waiting_room_talks", 0)) + 1
			GameState.flags["waiting_room_talks"] = count
			if count >= 3:
				_finish("VISITANTE RETIRADO", "Você esperou tanto que a segurança concluiu que esperar era sua atividade principal.")
			else:
				_feedback("Visitante: estou esperando alguém. Não lembro quem, mas a reunião deve começar em breve. Desde ontem.")
		"waiting_coffee":
			_feedback("A máquina oferece Café, Sem Café e Reunião. A terceira opção está indisponível por excesso de reuniões.")
		"auditorium_lucia":
			_open_auditorium_dialogue()
		"auditorium_stage":
			_feedback("No slide: 'ONBOARDING — porque entrar no prédio não significa que você entrou na empresa'.")
		"core_innovation_meeting":
			_call_core("innovation_meeting")
		"innovation_board":
			_feedback("POST-IT: 'Inovar é inventar algo que já existe e mudar o nome.'")
		"server_racks":
			_feedback("Os servidores piscam em perfeita sincronia. Isso preocupa mais do que tranquiliza.")
		"server_panel":
			_feedback("Etiqueta: NÃO DESLIGAR. Logo abaixo: 'reiniciar resolve 80%'.")
		"core_ti_service":
			_call_core("ti_service")
		"service_queue":
			_feedback("Chamado #000001: 'computador não liga'. Status: aguardando usuário desde 2019.")
		"core_rh_point":
			_call_core("rh_point")
		"core_rh_parallel":
			_call_core("rh_parallel")
		"core_rh_validator":
			_call_core("rh_validator")
		"registration_forms":
			_feedback("Formulário de cadastro: 14 campos obrigatórios. Três perguntam a mesma coisa com nomes diferentes.")
		"archive_domingos":
			_feedback("Domingos Hurley: você quer o original, a cópia, a segunda via ou a cópia da segunda via?")
		"core_documentation_printer":
			_call_core("documentation_printer")

func _call_core(action: String) -> void:
	var selected := ""
	var main := _get_main()
	if main != null:
		selected = str(main.get("selected_item"))
	GameFlow.perform(action, selected)
	if GameState.run_active and main != null and main.has_method("show_game"):
		main.call_deferred("show_game")

func _feedback(text: String) -> void:
	GameFlow.feedback.emit(text)
	var main := _get_main()
	if main != null and main.has_method("show_game"):
		main.call_deferred("show_game")

func _open_reception_totem() -> void:
	if GameState.has_flag("identified"):
		_feedback("Totem: cadastro localizado. Para alterar qualquer dado, abra um chamado. Prazo estimado: em breve.")
	else:
		_feedback("Totem — PRIMEIRO CADASTRO: Colaborador, Terceiro, Visitante ou Outro. A opção 'Entregador de Pizza' ainda está em homologação.")

func _open_receptionist_dialogue() -> void:
	if GameState.has_flag("identified"):
		_feedback("Eliana Marli: já está identificado. Ronaldo Gilberto, Diretoria, último andar. E sim, o elevador continua parado.")
		return
	DialogueUI.open_dialogue(
		"receptionist_intro",
		"Eliana Marli — Recepção",
		"Boa tarde. Posso ajudar?",
		[
			{"id":"A","key":"A","text":"Sou entregador. Vim entregar a pizza para o diretor."},
			{"id":"B","key":"B","text":"Quero entrar na empresa."},
			{"id":"C","key":"C","text":"Tenho uma entrega, mas não sei para quem."},
			{"id":"D","key":"D","text":"Estou esperando alguém."}
		]
	)

func _open_auditorium_dialogue() -> void:
	DialogueUI.open_dialogue(
		"auditorium_lucia",
		"Lúcia Pauta — Onboarding",
		"Finalmente! O palestrante chegou. Podemos começar?",
		[
			{"id":"A","key":"A","text":"Claro. Sou o palestrante."},
			{"id":"B","key":"B","text":"Coloca meu nome como 'Consultor Externo'."},
			{"id":"C","key":"C","text":"Posso fazer a apresentação. Mas a pizza vai esfriar."},
			{"id":"D","key":"D","text":"Acho que houve um engano. Sou o entregador."}
		]
	)

func _on_dialogue_choice(dialogue_id: String, choice_id: String) -> void:
	if dialogue_id == "receptionist_intro":
		match choice_id:
			"A":
				GameState.tick(2)
				GameState.set_flag("identified")
				GameState.add_item("visitor_badge")
				GameState.learn("director_name:ronaldo_gilberto")
				_feedback("Eliana Marli: Diretoria, para Ronaldo Gilberto. Aqui está seu crachá. Fale com a segurança.")
			"B":
				SceneRouter.route_to("reception_auditorium")
			"C":
				_finish("DESTINO NÃO ENCONTRADO", "A empresa possui processos para tudo. Descobrir o destinatário da pizza não é um deles.")
			"D":
				SceneRouter.route_to("reception_waiting_room")
	elif dialogue_id == "auditorium_lucia":
		match choice_id:
			"A":
				GameState.set_flag("temporary_rh_shortcut")
				AchievementManager.unlock("O palestrante atrasado")
				_feedback("Lúcia Pauta: perfeito! O RH estava esperando você. Você acaba de ganhar um atalho que não deveria existir.")
			"B":
				_finish("IDENTIDADE FALSIFICADA", "O cadastro aceitou a informação. A Segurança da Informação também aceitou — como incidente.")
			"C":
				GameState.tick(20)
				AchievementManager.unlock("Uma palestra de sucesso")
				GameState.set_flag("auditorium_completed")
				_feedback("A apresentação foi um sucesso. A pizza, por outro lado, ganhou vinte minutos de experiência corporativa.")
			"D":
				SceneRouter.route_to("reception")

func _finish(ending_name: String, message: String) -> void:
	EndingManager.register(ending_name)
	GameState.run_active = false
	GameFlow.finished.emit(ending_name, message)