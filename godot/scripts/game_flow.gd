extends Node

signal feedback(message: String)
signal finished(ending_name: String, message: String)

func perform(action_id: String) -> void:
	if not GameState.run_active:
		feedback.emit("Nenhuma partida ativa.")
		return
	GameState.tick(5)
	match action_id:
		"identify":
			GameState.learn("director_name:ronaldo_gilberto")
			GameState.add_item("visitor_badge")
			feedback.emit("INFORMAÇÃO ADQUIRIDA — Diretor: Ronaldo Gilberto")
			SceneRouter.route_to("innovation")
		"take_vr":
			GameState.add_item("vr_glasses")
			feedback.emit("Óculos VR adicionados ao inventário.")
			SceneRouter.route_to("ti")
		"solve_ti":
			if not GameState.has_item("vr_glasses"):
				feedback.emit("Rogério Wilco precisa do problema certo. Faltam os Óculos VR.")
				return
			GameState.set_flag("boss_ti_done")
			AchievementManager.unlock("Primeiro processo contornado")
			feedback.emit("P1 aberto. Rogério: CALMA BORIS! PROCESSO CONTORNADO.")
			SceneRouter.route_to("communication")
		"collect_communication":
			GameState.add_item("executive_priority_stamp")
			GameState.learn("cc_0001")
			feedback.emit("Carimbo — Prioridade Executiva + CC-0001 obtidos.")
			SceneRouter.route_to("supplies")
		"solve_supplies":
			if not GameState.has_item("executive_priority_stamp") or not GameState.knows("cc_0001"):
				feedback.emit("Stan Leilo ainda quer centro de custo e prioridade.")
				return
			GameState.set_flag("boss_supplies_done")
			AchievementManager.unlock("Compra emergencial")
			feedback.emit("JUSTIFICATIVA: FOME. Compra emergencial aprovada.")
			SceneRouter.route_to("hall")
		"visit_finance":
			SceneRouter.route_to("finance")
		"visit_engineering":
			SceneRouter.route_to("engineering")
		"continue_security":
			if not GameState.has_flag("finance_done") or not GameState.has_flag("engineering_done"):
				feedback.emit("Você pode tentar seguir, mas ainda faltam recursos de Financeiro e/ou Engenharia.")
				return
			SceneRouter.route_to("security")
		"collect_finance":
			GameState.add_item("third_party_proof")
			GameState.add_item("fiscal_exception_protocol")
			GameState.set_flag("finance_done")
			feedback.emit("Comprovante de Prestador + Protocolo de Exceção Fiscal obtidos.")
			SceneRouter.route_to("hall")
		"collect_engineering":
			GameState.add_item("maintenance_vest")
			GameState.add_item("work_order")
			GameState.set_flag("engineering_done")
			feedback.emit("Colete de Manutenção + OS obtidos.")
			SceneRouter.route_to("hall")
		"equip_vest":
			if not GameState.has_item("maintenance_vest"):
				feedback.emit("Você ainda não tem o Colete de Manutenção.")
				return
			GameState.equip_disguise("maintenance")
			feedback.emit("DISFARCE: MANUTENÇÃO")
		"present_os":
			if GameState.disguise != "maintenance" or not GameState.has_item("work_order"):
				feedback.emit("Só a OS não basta; só o colete também não.")
				return
			GameState.set_flag("boss_security_done")
			AchievementManager.unlock("Passou na cara dura")
			feedback.emit("ACESSO TÉCNICO AUTORIZADO — PROCESSO CONTORNADO.")
			SceneRouter.route_to("rh")
		"solve_rh":
			if not GameState.has_item("third_party_proof"):
				feedback.emit("Helena Folha: isso prova que você entrou, não que você existe para o RH.")
				return
			GameState.set_flag("point_digital")
			GameState.set_flag("point_parallel")
			GameState.set_flag("third_party_validated")
			GameState.add_item("rh_validation_signature")
			GameState.set_flag("boss_rh_done")
			feedback.emit("Ponto digital + paralelo + cadastro validados. Assinatura do RH obtida.")
			SceneRouter.route_to("documentation")
		"take_bolota":
			GameState.add_item("legal_bolota_pending")
			feedback.emit("Bolota do Jurídico — PENDENTE DE APROVAÇÃO.")
			SceneRouter.route_to("legal")
		"open_ticket":
			GameState.set_flag("legal_ticket")
			GameState.learn("ticket:48271")
			feedback.emit("CHAMADO ABERTO — Nº 48271 — prioridade P1.")
		"answer_external":
			if not GameState.has_flag("legal_ticket"):
				feedback.emit("O telefone ainda não tocou. Primeiro abra o chamado.")
				return
			GameState.set_flag("external_authorization")
			GameState.learn("external_authorization")
			feedback.emit("AUTORIZAÇÃO EXTERNA À EMPRESA — RECEBIDA.")
		"approve_bolota":
			var ready := GameState.has_flag("legal_ticket") and GameState.has_flag("external_authorization") and GameState.has_item("legal_bolota_pending") and GameState.has_item("rh_validation_signature") and GameState.has_item("fiscal_exception_protocol")
			if not ready:
				feedback.emit("Dr. Vítor Parecer: pelo menos um dos cinco requisitos ainda está pendente.")
				return
			GameState.remove_item("legal_bolota_pending")
			GameState.add_item("legal_bolota_approved")
			GameState.set_flag("boss_legal_done")
			feedback.emit("PROCESSO JURÍDICO CONCLUÍDO — PROCESSO CONTORNADO.")
			SceneRouter.route_to("directorate")
		"say_director":
			if not GameState.knows("director_name:ronaldo_gilberto"):
				feedback.emit("Carla Agenda: nome incorreto.")
				return
			_resolve_delivery()
		_:
			feedback.emit("Ação ainda não implementada nesta build.")

func _resolve_delivery() -> void:
	var possession := str(GameState.pizza.get("possession", "player"))
	var minutes := int(GameState.pizza.get("elapsed_minutes", 0))
	var temperature := int(GameState.pizza.get("temperature", 100))
	if possession != "player":
		_finish("SEM PIZZA", "Você chegou ao diretor sem a pizza.")
		return
	if minutes >= 150:
		_finish("ENTREGA TARDE DEMAIS", "Ronaldo Gilberto já desistiu do pedido.")
		return
	if temperature <= 25:
		_finish("PIZZA FRIA", "A entrega foi concluída. A satisfação, não.")
		return
	AchievementManager.unlock("PROTOCOLO: PIZZA")
	_finish("ENTREGA CONCLUÍDA", "Pizza entregue. O celular toca: NOVO PEDIDO — PAPO SAPÃO — último andar. NOVO PROTOCOLO INICIADO.")

func _finish(ending_name: String, message: String) -> void:
	EndingManager.register(ending_name)
	GameState.run_active = false
	finished.emit(ending_name, message)
