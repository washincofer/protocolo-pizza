class_name HotspotCatalog
extends RefCounted

const SOURCE_SIZES := {
	"menu": Vector2(1672, 941),
	"reception": Vector2(1672, 941),
	"reception_waiting_room": Vector2(1672, 941),
	"reception_auditorium": Vector2(1672, 941),
	"innovation": Vector2(1672, 941),
	"innovation_meeting_room": Vector2(1672, 941),
	"ti": Vector2(1672, 941),
	"ti_server_room": Vector2(1672, 941),
	"ti_service_desk": Vector2(1672, 941),
	"communication": Vector2(1672, 941),
	"supplies": Vector2(1672, 941),
	"hall": Vector2(1672, 941),
	"finance": Vector2(1672, 941),
	"engineering": Vector2(1672, 941),
	"security": Vector2(1672, 941),
	"rh": Vector2(1672, 941),
	"rh_time_control": Vector2(1672, 941),
	"rh_third_party_registration": Vector2(1672, 941),
	"documentation": Vector2(1672, 941),
	"documentation_archive_reprography": Vector2(1672, 941),
	"legal": Vector2(1672, 941),
	"directorate": Vector2(1672, 941)
}

const BACKGROUNDS := {
	"menu": "res://assets/scenarios/menu.png",
	"reception": "res://assets/scenarios/reception.png",
	"reception_waiting_room": "res://assets/subareas/reception_waiting_room.webp",
	"reception_auditorium": "res://assets/subareas/reception_auditorium.webp",
	"innovation": "res://assets/scenarios/innovation.png",
	"innovation_meeting_room": "res://assets/subareas/innovation_meeting_room.webp",
	"ti": "res://assets/scenarios/ti.png",
	"ti_server_room": "res://assets/subareas/ti_server_room.webp",
	"ti_service_desk": "res://assets/subareas/ti_service_desk.webp",
	"communication": "res://assets/scenarios/communication.png",
	"supplies": "res://assets/scenarios/supplies.png",
	"hall": "res://assets/scenarios/hall.png",
	"finance": "res://assets/scenarios/finance.png",
	"engineering": "res://assets/scenarios/engineering.png",
	"security": "res://assets/scenarios/security.png",
	"rh": "res://assets/scenarios/rh.png",
	"rh_time_control": "res://assets/subareas/rh_time_control.webp",
	"rh_third_party_registration": "res://assets/subareas/rh_third_party_registration.webp",
	"documentation": "res://assets/scenarios/documentation.png",
	"documentation_archive_reprography": "res://assets/subareas/documentation_archive_reprography.webp",
	"legal": "res://assets/scenarios/legal.png",
	"directorate": "res://assets/scenarios/directorate.png"
}

const TITLES := {
	"reception": "Recepção / Térreo",
	"reception_waiting_room": "Recepção — Sala de Espera",
	"reception_auditorium": "Recepção — Auditório / Onboarding",
	"innovation": "Inovação",
	"innovation_meeting_room": "Inovação — Sala de Reunião",
	"ti": "TI — Chefe 1",
	"ti_server_room": "TI — Sala de Servidores",
	"ti_service_desk": "TI — Service Desk",
	"communication": "Comunicação",
	"supplies": "Suprimentos — Chefe 2",
	"hall": "Hall Corporativo",
	"finance": "Financeiro",
	"engineering": "Engenharia",
	"security": "Vigilância — Chefe 3",
	"rh": "RH — Chefe 4",
	"rh_time_control": "RH — Controle de Ponto",
	"rh_third_party_registration": "RH — Cadastro de Terceiros",
	"documentation": "Documentação",
	"documentation_archive_reprography": "Documentação — Arquivo / Reprografia",
	"legal": "Jurídico — Chefe 5",
	"directorate": "Diretoria"
}

# Em áreas já calibradas, "bounds" preserva exatamente os quatro números
# medidos pelo F3 no formato [X1, Y1, X2, Y2]. O DebugTools usa esses limites
# como fonte autoritativa depois do enquadramento da imagem.
const HOTSPOTS := {
	"reception": [
		{"label":"Balcão da Recepção","rect":[500,320,270,219],"bounds":[500,539,770,320],"action":"receptionist"},
		{"label":"Sala de Espera","rect":[37,198,151,369],"bounds":[37,567,188,198],"action":"wait_sofa"},
		{"label":"Totem Primeiro Cadastro","rect":[792,352,98,202],"bounds":[792,554,890,352],"action":"reception_totem"},
		{"label":"Segurança","rect":[1027,340,129,205],"bounds":[1027,545,1156,340],"action":"security_desk"},
		{"label":"Auditório","rect":[1492,178,138,182],"bounds":[1492,360,1630,178],"action":"auditorium"},
		{"label":"Escadas","rect":[1535,440,126,347],"bounds":[1535,787,1661,440],"action":"reception_stairs"},
		{"label":"Porta de Entrada","rect":[366,760,964,170],"bounds":[366,930,1330,760],"action":"reception_exit"}
	],
	"innovation": [
		{"label":"Óculos VR","rect":[744,510,76,49],"bounds":[744,559,820,510],"action":"take_vr"},
		{"label":"Caio Brusch","rect":[819,383,94,195],"bounds":[819,578,913,383],"action":"talk_caio"},
		{"label":"Bernardo Nolli","rect":[380,427,92,123],"bounds":[380,550,472,427],"action":"talk_bernardo"},
		{"label":"Sala de Reunião","rect":[1030,110,238,510],"bounds":[1030,620,1268,110],"action":"innovation_meeting"},
		{"label":"Banheiro","rect":[1440,177,98,419],"bounds":[1440,596,1538,177],"action":"innovation_bathroom"},
		{"label":"Hall / saída para TI","rect":[0,90,170,520],"action":"innovation_exit"}
	],
	"ti": [
		{"label":"Rogério Wilco","rect":[1259,286,157,134],"bounds":[1259,420,1416,286],"action":"rogerio"},
		{"label":"Sala de Reunião / Weekly","rect":[998,66,180,496],"bounds":[998,562,1178,66],"action":"ti_weekly"},
		{"label":"Sala de Servidores","rect":[660,182,230,138],"bounds":[660,320,890,182],"action":"ti_server_room_entry"},
		{"label":"Service Desk","rect":[326,323,198,130],"bounds":[326,453,524,323],"action":"ti_service"},
		{"label":"Segurança da Informação","rect":[1412,452,207,267],"bounds":[1412,719,1619,452],"action":"ti_security"},
		{"label":"Voltar Inovação / Avançar Comunicação","rect":[0,182,164,314],"bounds":[0,496,164,182],"action":"ti_exit"}
	],
	"communication": [
		{"label":"Planejamento","rect":[1254,349,126,202],"bounds":[1254,551,1380,349],"action":"communication_board"},
		{"label":"Carimbo","rect":[504,762,99,66],"bounds":[504,828,603,762],"action":"communication_printer"},
		{"label":"Estúdio / Microfone","rect":[990,203,232,325],"bounds":[990,528,1222,203],"action":"communication_studio"},
		{"label":"Saída — TI / Suprimentos","rect":[113,190,177,416],"bounds":[113,606,290,190],"action":"communication_exit"}
	],
	"supplies": [
		{"label":"Stan Leilo / Aprovação de Compras","rect":[395,403,425,316],"bounds":[395,719,820,403],"action":"supplies_stan"},
		{"label":"Três Cotações","rect":[320,320,170,95],"bounds":[320,415,490,320],"action":"supplies_quotes"},
		{"label":"Almoxarifado","rect":[1217,180,323,503],"bounds":[1217,683,1540,180],"action":"supplies_warehouse"},
		{"label":"Sala de Compras","rect":[38,87,94,628],"bounds":[38,715,132,87],"action":"supplies_supplier"},
		{"label":"Saída — Comunicação / Hall","rect":[630,845,470,70],"bounds":[630,915,1100,845],"action":"supplies_exit"}
	],
	"hall": [
		{"label":"Financeiro","rect":[102,283,203,340],"bounds":[102,623,305,283],"action":"hall_finance"},
		{"label":"Engenharia","rect":[1406,248,195,376],"bounds":[1406,624,1601,248],"action":"hall_engineering"},
		{"label":"Escadas","rect":[714,178,245,94],"bounds":[714,272,959,178],"action":"hall_stairs"},
		{"label":"Painel de Diretórios","rect":[660,282,366,235],"bounds":[660,517,1026,282],"action":"hall_map"},
		{"label":"Banco de Espera","rect":[329,478,290,122],"bounds":[329,600,619,478],"action":"hall_wait"}
	],
	"finance": [
		{"label":"Bruno Basco","rect":[506,337,217,156],"bounds":[506,493,723,337],"action":"finance_bruno"},
		{"label":"Pasta de Reembolso","rect":[1267,204,103,130],"bounds":[1267,334,1370,204],"action":"finance_reimbursement"},
		{"label":"Calculadora","rect":[1062,583,65,67],"bounds":[1062,650,1127,583],"action":"finance_calculator"},
		{"label":"Arquivo / Carlos","rect":[1424,334,155,149],"bounds":[1424,483,1579,334],"action":"finance_archive"},
		{"label":"Voltar ao Hall","rect":[0,765,546,160],"bounds":[0,925,546,765],"action":"finance_back"}
	],
	"engineering": [
		{"label":"Colete de Manutenção","rect":[1225,587,86,113],"bounds":[1225,700,1311,587],"action":"engineering_vest"},
		{"label":"Ordem de Serviço","rect":[0,475,86,102],"bounds":[0,577,86,475],"action":"engineering_os"},
		{"label":"Bento Tróti","rect":[616,384,191,208],"bounds":[616,592,807,384],"action":"engineering_bento"},
		{"label":"Análise estrutural da pizza","rect":[392,436,76,77],"bounds":[392,513,468,436],"action":"engineering_analysis"},
		{"label":"Voltar ao Hall","rect":[1413,212,157,472],"bounds":[1413,684,1570,212],"action":"engineering_back"}
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
