class_name HotspotCatalog
extends RefCounted

const SOURCE_SIZES := {
	"menu": Vector2(1672, 941),
	"reception": Vector2(1672, 941),
	"innovation": Vector2(1672, 941),
	"ti": Vector2(1672, 941),
	"communication": Vector2(1448, 1086),
	"supplies": Vector2(1448, 1086),
	"hall": Vector2(1672, 941),
	"finance": Vector2(1672, 941),
	"engineering": Vector2(1672, 941),
	"security": Vector2(1448, 1086),
	"rh": Vector2(1448, 1086),
	"documentation": Vector2(1448, 1086),
	"legal": Vector2(1448, 1086),
	"directorate": Vector2(1448, 1086)
}

const BACKGROUNDS := {
	"menu": "res://assets/scenarios/menu.png",
	"reception": "res://assets/scenarios/reception.png",
	"innovation": "res://assets/scenarios/innovation.png",
	"ti": "res://assets/scenarios/ti.png",
	"communication": "res://assets/scenarios/communication.png",
	"supplies": "res://assets/scenarios/supplies.png",
	"hall": "res://assets/scenarios/hall.png",
	"finance": "res://assets/scenarios/finance.png",
	"engineering": "res://assets/scenarios/engineering.png",
	"security": "res://assets/scenarios/security.png",
	"rh": "res://assets/scenarios/rh.png",
	"documentation": "res://assets/scenarios/documentation.png",
	"legal": "res://assets/scenarios/legal.png",
	"directorate": "res://assets/scenarios/directorate.png"
}

const TITLES := {
	"reception": "Recepção / Térreo",
	"innovation": "Inovação",
	"ti": "TI — Chefe 1",
	"communication": "Comunicação",
	"supplies": "Suprimentos — Chefe 2",
	"hall": "Hall Corporativo",
	"finance": "Financeiro",
	"engineering": "Engenharia",
	"security": "Vigilância — Chefe 3",
	"rh": "RH — Chefe 4",
	"documentation": "Documentação",
	"legal": "Jurídico — Chefe 5",
	"directorate": "Diretoria"
}

const HOTSPOTS := {
	"reception": [
		{"label":"Balcão da Recepção","rect":[500,270,300,250],"action":"receptionist"},
		{"label":"Sofá de Espera","rect":[270,330,260,170],"action":"wait_sofa"},
		{"label":"Segurança","rect":[1010,270,170,250],"action":"security_desk"},
		{"label":"Auditório","rect":[1450,100,210,320],"action":"auditorium"},
		{"label":"Escadas","rect":[1450,420,210,320],"action":"reception_stairs"},
		{"label":"Porta de Entrada","rect":[0,150,190,430],"action":"reception_exit"}
	],
	"innovation": [
		{"label":"Óculos VR","rect":[900,380,190,170],"action":"take_vr"},
		{"label":"Caio Brusch","rect":[760,260,270,260],"action":"talk_caio"},
		{"label":"Bernardo Nolli","rect":[350,350,300,180],"action":"talk_bernardo"},
		{"label":"Sala de Reunião","rect":[1040,100,300,430],"action":"innovation_meeting"},
		{"label":"Banheiro","rect":[1430,110,220,500],"action":"innovation_bathroom"},
		{"label":"Hall / saída para TI","rect":[0,90,170,520],"action":"innovation_exit"}
	],
	"ti": [
		{"label":"Rogério Wilco","rect":[1120,180,300,340],"action":"rogerio"},
		{"label":"Sala de Reunião / Weekly","rect":[850,100,290,510],"action":"ti_weekly"},
		{"label":"Service Desk","rect":[250,150,430,370],"action":"ti_service"},
		{"label":"Segurança da Informação","rect":[1400,170,260,430],"action":"ti_security"}
	],
	"communication": [
		{"label":"Planejamento","rect":[1080,300,250,370],"action":"communication_board"},
		{"label":"Impressora","rect":[760,650,280,390],"action":"communication_printer"},
		{"label":"Estúdio / Microfone","rect":[790,160,310,470],"action":"communication_studio"},
		{"label":"Sala de Criação / saída","rect":[0,70,260,520],"action":"communication_exit"}
	],
	"supplies": [
		{"label":"Stan Leilo / Aprovação de Compras","rect":[300,260,500,360],"action":"supplies_stan"},
		{"label":"Três cotações","rect":[230,100,300,300],"action":"supplies_quotes"},
		{"label":"Almoxarifado","rect":[940,80,470,620],"action":"supplies_warehouse"},
		{"label":"Sala de Compras","rect":[0,90,270,500],"action":"supplies_supplier"}
	],
	"hall": [
		{"label":"Financeiro","rect":[0,220,330,430],"action":"hall_finance"},
		{"label":"Engenharia","rect":[1350,220,320,430],"action":"hall_engineering"},
		{"label":"Escadas","rect":[690,50,300,250],"action":"hall_stairs"},
		{"label":"Painel de Diretórios","rect":[650,250,370,300],"action":"hall_map"},
		{"label":"Banco de Espera","rect":[350,430,300,160],"action":"hall_wait"}
	],
	"finance": [
		{"label":"Bruno Basco","rect":[500,300,360,300],"action":"finance_bruno"},
		{"label":"Pasta de Reembolso","rect":[840,430,250,250],"action":"finance_reimbursement"},
		{"label":"Calculadora","rect":[1040,520,190,190],"action":"finance_calculator"},
		{"label":"Arquivo / Carlos","rect":[1320,260,330,360],"action":"finance_archive"},
		{"label":"Voltar ao Hall","rect":[0,160,190,480],"action":"finance_back"}
	],
	"engineering": [
		{"label":"Colete de Manutenção","rect":[930,210,260,350],"action":"engineering_vest"},
		{"label":"Ordem de Serviço","rect":[1160,430,250,230],"action":"engineering_os"},
		{"label":"Bento Tróti","rect":[520,260,330,330],"action":"engineering_bento"},
		{"label":"Análise estrutural da pizza","rect":[1370,250,280,390],"action":"engineering_analysis"},
		{"label":"Voltar ao Hall","rect":[0,140,210,500],"action":"engineering_back"}
	],
	"security": [
		{"label":"Sônia Bondes / Posto","rect":[520,300,420,330],"action":"security_sonia"},
		{"label":"Sala de Monitoramento","rect":[280,150,620,300],"action":"security_monitors"},
		{"label":"Acesso Restrito","rect":[1190,220,240,500],"action":"security_access"},
		{"label":"Detector / inspeção da pizza","rect":[1050,540,330,300],"action":"security_inspection"}
	],
	"rh": [
		{"label":"Helena Folha","rect":[390,300,420,330],"action":"rh_helena"},
		{"label":"Controle de Ponto","rect":[850,170,250,350],"action":"rh_point"},
		{"label":"Controle paralelo / Formulários","rect":[0,720,520,330],"action":"rh_parallel"},
		{"label":"Cadastro de Terceiros","rect":[1100,260,330,330],"action":"rh_validator"},
		{"label":"Micro-ondas","rect":[1050,620,330,320],"action":"rh_microwave"}
	],
	"documentation": [
		{"label":"Balcão de Atendimento","rect":[430,230,420,340],"action":"documentation_counter"},
		{"label":"Bolota do Jurídico","rect":[1080,330,300,340],"action":"documentation_bolota"},
		{"label":"Impressora / Cópias","rect":[900,620,400,420],"action":"documentation_printer"},
		{"label":"Escadas / Jurídico","rect":[1270,650,170,360],"action":"documentation_exit"}
	],
	"legal": [
		{"label":"Laura Firma / Recepção","rect":[300,300,380,320],"action":"legal_secretary"},
		{"label":"Telefone / chamado","rect":[590,300,190,220],"action":"legal_phone"},
		{"label":"Dr. Vítor Parecer / Mesa de Análise","rect":[760,330,390,380],"action":"legal_analysis"},
		{"label":"Termos e Condições","rect":[1100,120,320,350],"action":"legal_terms"}
	],
	"directorate": [
		{"label":"Carla Agenda / Secretaria","rect":[500,350,350,300],"action":"director_secretary"},
		{"label":"Gabinete do Diretor","rect":[930,150,300,520],"action":"director_door"},
		{"label":"Revistas","rect":[250,530,300,180],"action":"director_magazines"}
	]
}

static func get_source_size(area_id: String) -> Vector2:
	return SOURCE_SIZES.get(area_id, Vector2(1672, 941))

static func get_background(area_id: String) -> String:
	return str(BACKGROUNDS.get(area_id, BACKGROUNDS["reception"]))

static func get_title(area_id: String) -> String:
	return str(TITLES.get(area_id, area_id))

static func get_hotspots(area_id: String) -> Array:
	return Array(HOTSPOTS.get(area_id, []))
