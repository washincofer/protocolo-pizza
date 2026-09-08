extends Node

signal feedback(text: String)
signal finished(ending_name: String, message: String)

func perform(action_id: String, selected_item := "") -> void:
	if not GameState.run_active:
		return
	GameState.tick(2)
	match action_id:
		"receptionist":
			GameState.set_flag("identified")
			GameState.add_item("visitor_badge")
			GameState.learn("director_name:ronaldo_gilberto")
			feedback.emit("Eliana Marli: Pizza para a Diretoria? Para Ronaldo Gilberto. Crachá liberado.")
		"wait_sofa":
			var count := int(GameState.flags.get("wait_clicks", 0)) + 1
			GameState.flags["wait_clicks"] = count
			if count >= 3:
				_finish("VISITANTE RETIRADO", "Você esperou tanto que virou parte do mobiliário. A segurança resolveu o problema.")
			else:
				feedback.emit("O visitante ao lado ainda está esperando. Ele não lembra por quem.")
		"security_desk":
			if GameState.has_flag("identified"):
				GameState.set_flag("security_cleared")
				feedback.emit("Mauro Portela: Crachá ok. Elevadores indisponíveis. Vai pela escada.")
			else:
				feedback.emit("Mauro Portela: primeiro se identifique na Recepção.")
		"auditorium":
			feedback.emit("Lúcia Pauta acha que você é o palestrante. Melhor não sustentar essa ideia por muito tempo.")
		"reception_stairs":
			if not GameState.has_flag("identified"):
				feedback.emit("A segurança bloqueia a passagem. Identifique-se primeiro.")
				return
			SceneRouter.route_to("innovation")
		"reception_exit":
			if int(GameState.pizza.get("elapsed_minutes", 0)) <= 4:
				AchievementManager.unlock("Nem iniciou o jogo")
			_finish("ENTREGA ABANDONADA", "Você evitou toda a burocracia. Inclusive a entrega.")
		"take_vr":
			GameState.add_item("vr_glasses")
			feedback.emit("Óculos VR coletados. Talvez alguém da TI se interesse.")
		"talk_caio":
			feedback.emit("Caio Brusch: estamos reinventando uma experiência que já existia, mas agora com outro nome.")
		"talk_bernardo":
			feedback.emit("Bernardo Nolli: Psiu, fica quietinho fica. O post-it físico está sincronizando com o digital.")
		"innovation_meeting":
			GameState.set_flag("poor_collaboration")
			feedback.emit("Você sai antes da introdução terminar. Registro criado: Pouco colaborativo.")
		"innovation_bathroom":
			var c := int(GameState.flags.get("bathroom_clicks", 0)) + 1
			GameState.flags["bathroom_clicks"] = c
			if c >= 3:
				AchievementManager.unlock("Logística Reversa")
				_finish("ENTREGA POR ENCANAMENTO", "A logística reversa funcionou. A pizza não voltou.")
			else:
				feedback.emit("Placa: Só pode cagar no seu andar.")
		"innovation_exit":
			if not GameState.has_item("vr_glasses"):
				feedback.emit("Ainda existe um Óculos VR brilhando de forma suspeita no cenário.")
				return
			SceneRouter.route_to("ti")
		"rogerio":
			if selected_item != "vr_glasses":
				feedback.emit("Rogério Wilco: Já tivemos nossa weekly hoje? Tente usar o item certo nele.")
				return
			GameState.set_flag("boss_ti_done")
			AchievementManager.unlock("Primeiro processo contornado")
			feedback.emit("CALMA BORIS! O VR virou P1. Rogério abandona o bloqueio — PROCESSO CONTORNADO.")
			SceneRouter.route_to("communication")
		"ti_weekly":
			AchievementManager.unlock("Weekly eterna")
			_finish("REUNIÃO RECORRENTE", "A reunião acabou. A próxima começou antes.")
		"ti_service":
			_finish("ENTREGA DIGITALMENTE CONCLUÍDA", "O Service Desk marcou a pizza como entregue. A realidade abriu chamado.")
		"ti_security":
			_finish("INCIDENTE DE SEGURANÇA", "Jorge Stobarte reteve a pizza para análise por tempo indeterminado.")
		"communication_board":
			GameState.learn("cc_0001")
			feedback.emit("Informação adquirida: CC-0001 — Centro de custo da Diretoria.")
		"communication_printer":
			GameState.add_item("executive_priority_stamp")
			feedback.emit("Carimbo — Prioridade Executiva obtido.")
		"communication_studio":
			feedback.emit("Microfone: olá, olá, oláaaa... olááá. A vinheta ecoa pelo andar.")
		"communication_exit":
			if not GameState.knows("cc_0001") or not GameState.has_item("executive_priority_stamp"):
				feedback.emit("Antes de sair, você ainda precisa do CC-0001 e do Carimbo de Prioridade Executiva.")
				return
			SceneRouter.route_to("supplies")
		"supplies_stan":
			if selected_item != "executive_priority_stamp":
				feedback.emit("Stan Leilo: prioridade sem carimbo não é prioridade.")
				return
			if not GameState.knows("cc_0001"):
				feedback.emit("Stan Leilo: e o centro de custo?")
				return
			GameState.set_flag("boss_supplies_done")
			AchievementManager.unlock("Compra emergencial")
			feedback.emit("JUSTIFICATIVA: FOME. Compra emergencial aprovada — PROCESSO CONTORNADO.")
			SceneRouter.route_to("hall")
		"supplies_quotes":
			AchievementManager.unlock("Economia de R$ 2")
			_finish("MENOR PREÇO", "Sua pizza perdeu a concorrência por dois reais.")
		"supplies_warehouse":
			_finish("MATERIAL RETIDO", "Murray Estoque colocou a pizza em quarentena administrativa.")
		"supplies_supplier":
			_finish("FORNECEDOR HOMOLOGADO", "A degustação técnica aprovou o produto e consumiu a evidência.")
		"hall_finance":
			SceneRouter.route_to("finance")
		"hall_engineering":
			SceneRouter.route_to("engineering")
		"hall_stairs":
			if not GameState.has_flag("finance_done") or not GameState.has_flag("engineering_done"):
				feedback.emit("Você ainda não reuniu tudo que precisa em Financeiro e Engenharia.")
				return
			SceneRouter.route_to("security")
		"hall_map":
			AchievementManager.unlock("Agora fiquei mais perdido")
			feedback.emit("Continuo sem saber onde estou.")
		"hall_wait":
			var visited := bool(GameState.flags.get("hall_waited", false))
			if visited and (GameState.has_flag("finance_done") or GameState.has_flag("engineering_done")):
				AchievementManager.unlock("Ainda esperando")
			GameState.set_flag("hall_waited")
			feedback.emit("O funcionário continua esperando. Agora por princípio.")
		"finance_bruno":
			GameState.add_item("third_party_proof")
			GameState.add_item("fiscal_exception_protocol")
			GameState.set_flag("finance_done")
			feedback.emit("Bruno Basco emitiu o Comprovante de Prestador. Fábio Tributo liberou o Protocolo de Exceção Fiscal.")
		"finance_reimbursement":
			feedback.emit("Anexos obrigatórios? Depende de quem analisa.")
		"finance_calculator":
			AchievementManager.unlock("Dados Protegidos")
			feedback.emit("Dados da pizza classificados como confidenciais. Borda recheada: não podemos confirmar nem negar.")
		"finance_archive":
			feedback.emit("Beto Rô procura um borderô. Ele ainda não sabe o que é.")
		"finance_back":
			SceneRouter.route_to("hall")
		"engineering_vest":
			GameState.add_item("maintenance_vest")
			feedback.emit("Colete de Manutenção obtido. Clique nele no inventário para selecionar; clique novamente para vestir.")
		"engineering_os":
			if not GameState.has_item("maintenance_vest"):
				feedback.emit("A OS está no bolso do colete. Pegue o colete primeiro.")
				return
			GameState.add_item("work_order")
			GameState.set_flag("engineering_done")
			feedback.emit("Ordem de Serviço encontrada no bolso do Colete.")
		"engineering_bento":
			feedback.emit("Bento Tróti: Nem eu tenho coragem para entrar neste prédio construído por nós. — Por isso mesmo.")
		"engineering_analysis":
			_finish("FALHA ESTRUTURAL", "A pizza não atendeu aos requisitos mínimos de engenharia.")
		"engineering_back":
			if GameState.has_item("maintenance_vest") and GameState.has_item("work_order"):
				GameState.set_flag("engineering_done")
			SceneRouter.route_to("hall")
		"equip_vest":
			if not GameState.has_item("maintenance_vest"):
				return
			GameState.equip_disguise("maintenance")
			feedback.emit("Colete equipado — DISFARCE: MANUTENÇÃO.")
		"security_sonia":
			if selected_item != "work_order":
				feedback.emit("Sônia Bondes: documento?")
				return
			if GameState.disguise != "maintenance":
				feedback.emit("A OS parece válida, mas você ainda está vestido como entregador.")
				return
			GameState.set_flag("boss_security_done")
			AchievementManager.unlock("Passou na cara dura")
			feedback.emit("ACESSO TÉCNICO AUTORIZADO — PROCESSO CONTORNADO.")
			SceneRouter.route_to("rh")
		"security_monitors":
			var m := int(GameState.flags.get("monitor_clicks", 0)) + 1
			GameState.flags["monitor_clicks"] = m
			if m >= 3:
				AchievementManager.unlock("Big Brother Corporativo")
			feedback.emit("Uma câmera mostra outra câmera mostrando outra câmera.")
		"security_access":
			_finish("ÁREA RESTRITA", "Você tentou atravessar sem fechar o processo de acesso técnico.")
		"security_inspection":
			AchievementManager.unlock("Amostragem destrutiva")
			_finish("PIZZA EM QUARENTENA", "Inspeção concluída. Amostra indisponível para entrega.")
		"rh_helena":
			if not GameState.has_item("third_party_proof"):
				feedback.emit("Helena Folha: isso prova que você entrou, não que você existe para o RH.")
				return
			if not GameState.has_flag("rh_form"):
				GameState.set_flag("rh_form")
				GameState.add_item("third_party_form")
				feedback.emit("Ficha de Validação de Terceiro emitida. Agora registre o ponto.")
				return
			if GameState.has_flag("point_digital") and GameState.has_flag("point_parallel") and GameState.has_flag("third_party_validated"):
				GameState.add_item("rh_validation_signature")
				GameState.set_flag("boss_rh_done")
				feedback.emit("Helena assina. ASSINATURA DE VALIDAÇÃO DO RH obtida — PROCESSO CONTORNADO.")
				SceneRouter.route_to("documentation")
			else:
				feedback.emit("Helena: ainda faltam validações internas.")
		"rh_point":
			if not GameState.has_flag("rh_form"):
				feedback.emit("Sem ficha, sem ponto. Volte à Helena.")
				return
			GameState.set_flag("point_digital")
			feedback.emit("PONTO REGISTRADO NO SISTEMA. Paulo Pontes: falta o paralelo.")
		"rh_parallel":
			if not GameState.has_flag("point_digital"):
				feedback.emit("Primeiro registre no sistema digital.")
				return
			GameState.set_flag("point_parallel")
			feedback.emit("PONTO REGISTRADO NO CONTROLE PARALELO.")
		"rh_validator":
			if not GameState.has_flag("point_digital") or not GameState.has_flag("point_parallel"):
				feedback.emit("O validador exige os dois registros de ponto.")
				return
			GameState.set_flag("third_party_validated")
			feedback.emit("VALIDAÇÃO 2/2 — TERCEIRO REGULAR. Volte à Helena.")
		"rh_microwave":
			var temp := int(GameState.pizza.get("temperature", 100))
			if temp < 100:
				GameState.pizza["temperature"] = 100
				feedback.emit("MICRO-ONDAS DO RH: temperatura restaurada para 100%.")
			else:
				feedback.emit("A pizza já está quente. Até o RH concordou.")
		"documentation_counter":
			feedback.emit("Célia Viana: original, cópia, segunda via ou cópia da segunda via?")
		"documentation_bolota":
			GameState.add_item("legal_bolota_pending")
			feedback.emit("Bolota do Jurídico — PENDENTE DE APROVAÇÃO.")
		"documentation_printer":
			feedback.emit("Domingos Hurley imprime o digital para digitalizar oficialmente.")
		"documentation_exit":
			if not GameState.has_item("legal_bolota_pending"):
				feedback.emit("Você ainda precisa da Bolota do Jurídico.")
				return
			SceneRouter.route_to("legal")
		"legal_secretary":
			feedback.emit("Laura Firma confere Bolota, Assinatura e Protocolo. Falta o chamado.")
		"legal_phone":
			if not GameState.has_flag("legal_ticket"):
				GameState.set_flag("legal_ticket")
				GameState.learn("ticket:48271")
				feedback.emit("CHAMADO ABERTO — Nº 48271 — P1.")
			elif not GameState.has_flag("external_authorization"):
				GameState.set_flag("external_authorization")
				GameState.learn("external_authorization")
				feedback.emit("AUTORIZAÇÃO EXTERNA À EMPRESA — RECEBIDA. Por quem? Externamente.")
			else:
				feedback.emit("O telefone agora está estranhamente silencioso.")
		"legal_analysis":
			if selected_item != "legal_bolota_pending":
				feedback.emit("Dr. Vítor Parecer: coloque a Bolota pendente na mesa de análise.")
				return
			var ready := GameState.has_flag("legal_ticket") and GameState.has_flag("external_authorization") and GameState.has_item("rh_validation_signature") and GameState.has_item("fiscal_exception_protocol")
			if not ready:
				feedback.emit("Pelo menos um dos cinco requisitos ainda está pendente.")
				return
			GameState.remove_item("legal_bolota_pending")
			GameState.add_item("legal_bolota_approved")
			GameState.set_flag("boss_legal_done")
			feedback.emit("BOLOTA APROVADA — PROCESSO JURÍDICO CONCLUÍDO.")
			SceneRouter.route_to("directorate")
		"legal_terms":
			AchievementManager.unlock("Termos e Condições")
			_finish("LI E ACEITO", "Você não leu. Mas aceitou com muita convicção.")
		"director_secretary":
			GameState.set_flag("director_question")
			feedback.emit("Carla Agenda: Qual o nome do diretor?")
		"director_answer_correct":
			if GameState.knows("director_name:ronaldo_gilberto"):
				GameState.set_flag("director_access")
				GameState.set_flag("director_question", false)
				feedback.emit("Carla Agenda: Pode entrar. — Só isso? — Só isso o quê?")
		"director_answer_wrong":
			var wrong := int(GameState.flags.get("wrong_director", 0)) + 1
			GameState.flags["wrong_director"] = wrong
			if wrong >= 3:
				_finish("DIRETOR DESCONHECIDO", "Você atravessou a empresa inteira. Só esqueceu para quem era a pizza.")
			else:
				feedback.emit("Carla Agenda: Não.")
		"director_door":
			if not GameState.has_flag("director_access"):
				feedback.emit("Carla Agenda ainda não liberou a entrada.")
				return
			_resolve_delivery()
		"director_magazines":
			feedback.emit("Revista interna: 'Simplificando processos — edição especial de 248 páginas'.")
		_:
			feedback.emit("Nada útil aconteceu. O que, nesta empresa, já é alguma coisa.")

func equip_item(item_id: String) -> void:
	if item_id == "maintenance_vest":
		perform("equip_vest", item_id)

func _resolve_delivery() -> void:
	var possession := str(GameState.pizza.get("possession", "player"))
	var minutes := int(GameState.pizza.get("elapsed_minutes", 0))
	var temperature := int(GameState.pizza.get("temperature", 100))
	if possession != "player":
		_finish("SEM PIZZA", "Você chegou ao diretor sem a pizza.")
	elif minutes >= 150:
		_finish("ENTREGA TARDE DEMAIS", "Ronaldo Gilberto já desistiu do pedido.")
	elif temperature <= 25:
		_finish("PIZZA FRIA", "A entrega foi concluída. A satisfação, não.")
	else:
		AchievementManager.unlock("PROTOCOLO: PIZZA")
		_finish("ENTREGA CONCLUÍDA", "Ronaldo Gilberto recebe a pizza. O celular toca: NOVO PEDIDO — PAPO SAPÃO — último andar. NOVO PROTOCOLO INICIADO.")

func _finish(ending_name: String, message: String) -> void:
	EndingManager.register(ending_name)
	GameState.run_active = false
	finished.emit(ending_name, message)
