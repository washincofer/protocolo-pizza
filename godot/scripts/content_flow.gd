extends Node
const DIALOGUES: Dictionary = {
	"reception_insist_security":["Mauro Portela","Sem identificação, insistir pode levar à retenção da pizza.",[["A","Insistir sem identificação."],["B","Voltar e me identificar."]]],
	"reception_insist_stairs":["Mauro Portela","Forçar a passagem encerrará sua visita.",[["A","Tentar atravessar mesmo assim."],["B","Regularizar o acesso."]]],
	"waiting_guard":["Mauro Portela","Você está esperando há algum tempo. Quer resolver a identificação?",[["A","Voltar à Recepção."],["B","Explicar a entrega e aguardar."],["C","Insistir sem explicar e aceitar a retirada."]]],
	"innovation_meeting":["Reunião de Inovação","E se o diretor viesse buscar a própria pizza?",[["A","Aprovar e deixar a entrega por conta dele."],["B","Sair antes da introdução terminar."],["C","Ouvir e explicar minha entrega."]]],
	"ti_weekly":["Rogério Wilco","Temos uma weekly sobre a weekly. Quer entrar?",[["A","Participar de todas as reuniões."],["B","Continuar a entrega."]]],
	"ti_service":["Samir Maxo","O sistema pode concluir a entrega sem o diretor recebê-la.",[["A","Concluir digitalmente."],["B","Manter o chamado e a entrega física."]]],
	"ti_security":["Jorge Stobarte","A análise reterá a pizza por tempo indeterminado.",[["A","Entregar para análise."],["B","Manter a pizza comigo."]]],
	"ti_virtualize":["Sistemas","Migrar para Pizza as a Service faz a pizza deixar de existir fisicamente.",[["A","Aceitar virtualização."],["B","Continuar entrega física."]]],
	"finance_bruno":["Bruno Basco","Você é visitante, prestador ou parte do mobiliário?",[["A","Sou entregador, prestador da pizzaria."],["B","Sou visitante."],["C","Cadastrar-me permanentemente como terceirizado."]]],
	"finance_reimbursement":["Fábio Tributo","Antes da entrega: e a nota fiscal?",[["A","Mostrar NF e consultar documentos."],["B","Explicar que o pedido é de Ronaldo Gilberto."],["C","Declarar que não tenho NF e aceitar retenção."],["D","Tratar dados da pizza como confidenciais."]]],
	"engineering_analysis":["Bento Tróti","A análise é destrutiva; a pizza pode não voltar.",[["A","Autorizar análise destrutiva."],["B","Manter a pizza para o destinatário."],["C","Deixar a pizza e continuar sem ela."]]],
	"security_access":["Acesso Restrito","Atravessar sem autorização técnica encerra a visita.",[["A","Atravessar sem autorização."],["B","Voltar ao posto da Sônia."]]],
	"security_inspection":["Inspeção","A pizza inteira é a amostra e não será devolvida. Autoriza?",[["A","Autorizar inspeção."],["B","Recusar e continuar."]]],
	"rh_collaboration":["Helena Folha","A Inovação registrou Pouco colaborativo. Quer explicar?",[["A","Eu nem trabalho aqui; só quero entregar."],["B","Aceitar desligamento antes da contratação."],["C","Esclarecer o objetivo da visita."]]],
	"rh_employee":["Cadastro de Terceiros","Este formulário é para funcionários. Tem certeza?",[["A","Aceitar admissão como funcionário."],["B","Manter cadastro de terceiro."]]],
	"rh_heat_exit":["Helena Folha","A pizza está esfriando. O micro-ondas restaura temperatura, mas não recupera tempo.",[["A","Ficar no RH para aquecer."],["B","Continuar sem aquecer."]]],
	"legal_terms":["Termos e Condições","A aceitação transfere sua pizza ao processo.",[["A","Aceitar os termos."],["B","Manter a entrega física."]]],
	"legal_secretary":["Laura Firma","Faltam requisitos? Você pode resolver as pendências ou permanecer em análise.",[["A","Conferir pendências."],["B","Aceitar análise por tempo indeterminado."]]]
}
const AREAS: Dictionary = {"reception_insist_security":"reception","reception_insist_stairs":"reception","waiting_guard":"reception_waiting_room","innovation_meeting":"innovation_meeting_room","ti_weekly":"ti","ti_service":"ti_service_desk","ti_security":"ti","ti_virtualize":"ti_systems_room","finance_bruno":"finance","finance_reimbursement":"finance","engineering_analysis":"engineering","security_access":"security","security_inspection":"security","rh_collaboration":"rh","rh_employee":"rh_third_party_registration","rh_heat_exit":"rh","legal_terms":"legal","legal_secretary":"legal"}
func _ready() -> void:
	DialogueUI.choice_selected.connect(_on_choice)
func open_action(action: String) -> void:
	if not DIALOGUES.has(action): return
	var data: Array = DIALOGUES[action]
	var choices: Array = []
	for entry: Array in data[2]: choices.append({"id":entry[0],"key":entry[0],"text":entry[1]})
	DialogueUI.open_dialogue("content_"+action,data[0],data[1],choices)
func _on_choice(id: String,choice: String) -> void:
	if not GameState.run_active or not id.begins_with("content_"): return
	var action: String = id.trim_prefix("content_")
	if not DIALOGUES.has(action): return
	var expected: String = AREAS[action]
	if expected != GameState.current_area and not (action == "innovation_meeting" and GameState.current_area == "innovation") and not (action == "ti_service" and GameState.current_area == "ti") and not (action == "ti_security" and GameState.current_area == "ti_server_room"): return
	match action:
		"waiting_guard":
			if choice == "A": SceneRouter.route_to("reception")
			elif choice == "B": GameFlow.feedback.emit("Mauro: tudo bem. Volte à Recepção quando quiser continuar.")
			else: GameFlow._finish("VISITANTE RETIRADO","A segurança encerrou sua espera sem identificação.")
		"finance_bruno":
			if choice == "A":
				GameState.add_item("third_party_proof")
				GameFlow.feedback.emit("Comprovante emitido. Consulte a Pasta de Reembolso para a exceção fiscal.")
			elif choice == "C":
				AchievementManager.unlock("Agora eu trabalho aqui")
				GameFlow._finish("PROMOVIDO A TERCEIRIZADO","Você resolveu o vínculo. A entrega virou contrato permanente.")
			else: GameFlow.feedback.emit("Um crachá de visitante não comprova o vínculo de prestador.")
		"finance_reimbursement":
			if choice == "B":
				if not GameState.has_item("third_party_proof"):
					GameFlow.feedback.emit("Primeiro explique seu vínculo ao Bruno.")
					return
				GameState.add_item("fiscal_exception_protocol")
				GameState.set_flag("finance_done")
				GameFlow.feedback.emit("Exceção fiscal do pedido do diretor aprovada.")
			elif choice == "C":
				AchievementManager.unlock("Importação Irregular")
				GameFlow._finish("PIZZA SOB CUSTÓDIA FISCAL","A ausência de nota transferiu a pizza ao processo fiscal.")
			elif choice == "D":
				AchievementManager.unlock("Dados Protegidos")
				GameFlow.feedback.emit("Borda recheada: não podemos confirmar nem negar.")
			else: GameFlow.feedback.emit("Agora querem PIS, COFINS e classificação da borda. Explique o destinatário.")
		"innovation_meeting":
			if choice == "A": GameFlow._finish("INOVAÇÃO DEMAIS","A ideia avançou. A entrega ficou para o diretor buscar.")
			elif choice == "B":
				GameState.set_flag("poor_collaboration")
				GameFlow.feedback.emit("Registro Pouco colaborativo encaminhado ao RH.")
			else: GameFlow.feedback.emit("A proposta continua. O diretor espera a pizza física.")
		"engineering_analysis":
			if choice == "A": GameFlow._finish("FALHA ESTRUTURAL","A amostra inteira foi destruída na análise.")
			elif choice == "C":
				GameState.pizza["possession"] = "lost"
				GameState.pizza["quantity"] = 0
				GameFlow.feedback.emit("Você deixou a pizza. Retome o checkpoint para recuperá-la.")
		"rh_collaboration":
			if choice in ["A","B"]:
				AchievementManager.unlock("Experiência profissional de 0 dias")
				GameFlow._finish("DEMITIDO ANTES DE SER CONTRATADO","O RH encerrou um vínculo que nem começou.")
			else:
				GameState.set_flag("collaboration_resolved")
				GameFlow.feedback.emit("Ocorrência esclarecida. Você pode continuar o cadastro.")
		"rh_heat_exit":
			if choice == "B":
				GameState.set_flag("rh_heat_confirmed")
				GameFlow.perform("rh_helena")
		"rh_employee":
			if choice == "A":
				AchievementManager.unlock("Contratado sem entrevista")
				GameFlow._finish("EFETIVADO POR ENGANO","Sua entrega foi convertida em contratação.")
		"legal_secretary":
			if choice == "B": GameFlow._finish("EM ANÁLISE","A pizza aguarda análise por tempo indeterminado.")
			else: GameFlow.feedback.emit("Pendências: " + missing_legal() + ". O telefone abre o chamado e recebe a autorização na próxima ligação.")
		_:
			if choice != "A": return
			var endings: Dictionary = {"reception_insist_security":"PIZZA APREENDIDA","reception_insist_stairs":"ACESSO NÃO AUTORIZADO","ti_weekly":"REUNIÃO RECORRENTE","ti_service":"ENTREGA DIGITALMENTE CONCLUÍDA","ti_security":"INCIDENTE DE SEGURANÇA","ti_virtualize":"PIZZA AS A SERVICE","security_access":"ÁREA RESTRITA","security_inspection":"PIZZA EM QUARENTENA","legal_terms":"LI E ACEITO"}
			var achievements: Dictionary = {"ti_weekly":"Weekly eterna","ti_virtualize":"Pizza as a Service","security_inspection":"Amostragem destrutiva","legal_terms":"Termos e Condições"}
			if achievements.has(action): AchievementManager.unlock(achievements[action])
			if endings.has(action): GameFlow._finish(endings[action],"Sua escolha encerrou a entrega física. O final foi registrado.")
func missing_legal() -> String:
	var missing: PackedStringArray = []
	for entry: Array in ExperienceUI.legal_requirements():
		if not bool(entry[1]): missing.append(entry[0])
	return "nenhuma" if missing.is_empty() else ", ".join(missing)
