class_name AreaCatalog
extends RefCounted

const AREAS := {
	"reception": {
		"title": "Recepção / Térreo",
		"background": "res://assets/scenarios/reception.png",
		"description": "A primeira barreira da PAPO SAPÃO. Identifique a entrega e descubra para quem a pizza deve chegar.",
		"actions": [["identify", "Identificar entrega para Ronaldo Gilberto"]]
	},
	"innovation": {
		"title": "Inovação",
		"background": "res://assets/scenarios/innovation.png",
		"description": "Post-its, termos em inglês e uma solução que precisa urgentemente de outra solução.",
		"actions": [["take_vr", "Coletar Óculos VR e seguir para TI"]]
	},
	"ti": {
		"title": "TI — Chefe 1",
		"background": "res://assets/scenarios/ti.png",
		"description": "Rogério Wilco só abandona o bloqueio quando o problema certo vira P1.",
		"actions": [["solve_ti", "Usar Óculos VR com Rogério Wilco"]]
	},
	"communication": {
		"title": "Comunicação",
		"background": "res://assets/scenarios/communication.png",
		"description": "A marca precisa estar alinhada. A pizza também.",
		"actions": [["collect_communication", "Obter Carimbo e descobrir CC-0001"]]
	},
	"supplies": {
		"title": "Suprimentos — Chefe 2",
		"background": "res://assets/scenarios/supplies.png",
		"description": "Se existe, alguém precisa aprovar a compra. Se é pizza do diretor, a justificativa é Fome.",
		"actions": [["solve_supplies", "Abrir compra emergencial — Justificativa: Fome"]]
	},
	"hall": {
		"title": "Hall Corporativo",
		"background": "res://assets/scenarios/hall.png",
		"description": "Primeiro hub real. Financeiro e Engenharia podem ser visitados em qualquer ordem.",
		"actions": [["visit_finance", "Ir ao Financeiro"], ["visit_engineering", "Ir à Engenharia"], ["continue_security", "Seguir para Vigilância"]]
	},
	"finance": {
		"title": "Financeiro",
		"background": "res://assets/scenarios/finance.png",
		"description": "Nota fiscal, exceção fiscal e a difícil tarefa de provar que você é um prestador terceirizado.",
		"actions": [["collect_finance", "Obter Comprovante e Protocolo de Exceção Fiscal"]]
	},
	"engineering": {
		"title": "Engenharia",
		"background": "res://assets/scenarios/engineering.png",
		"description": "PROVISÓRIO DESDE 2018. Aqui estão o Colete de Manutenção e a Ordem de Serviço.",
		"actions": [["collect_engineering", "Coletar Colete e verificar a OS no bolso"]]
	},
	"security": {
		"title": "Vigilância — Chefe 3",
		"background": "res://assets/scenarios/security.png",
		"description": "Acesso técnico só funciona com aparência técnica e papel técnico.",
		"actions": [["equip_vest", "Equipar Colete de Manutenção"], ["present_os", "Apresentar Ordem de Serviço"]]
	},
	"rh": {
		"title": "RH — Chefe 4",
		"background": "res://assets/scenarios/rh.png",
		"description": "Sistema de ponto, controle paralelo, cadastro de terceiros e uma assinatura que só Helena Folha pode dar.",
		"actions": [["solve_rh", "Executar validações do RH e obter assinatura"]]
	},
	"documentation": {
		"title": "Documentação",
		"background": "res://assets/scenarios/documentation.png",
		"description": "Original, cópia, segunda via e a lendária Bolota do Jurídico — ainda pendente de aprovação.",
		"actions": [["take_bolota", "Obter Bolota do Jurídico — Pendente"]]
	},
	"legal": {
		"title": "Jurídico — Chefe 5",
		"background": "res://assets/scenarios/legal.png",
		"description": "O chefe burocrático final. Chamado, Bolota, Assinatura, Protocolo e Autorização Externa.",
		"actions": [["open_ticket", "Abrir chamado"], ["answer_external", "Atender autorização externa"], ["approve_bolota", "Submeter os cinco requisitos"]]
	},
	"directorate": {
		"title": "Diretoria",
		"background": "res://assets/scenarios/directorate.png",
		"description": "Depois de tudo isso, Carla Agenda só quer saber uma coisa: qual é o nome do diretor?",
		"actions": [["say_director", "Responder: Ronaldo Gilberto"]]
	}
}

static func get_area(area_id: String) -> Dictionary:
	return AREAS.get(area_id, AREAS["reception"])
