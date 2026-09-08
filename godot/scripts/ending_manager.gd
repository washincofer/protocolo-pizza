extends Node

signal ending_registered(name: String)

const SAVE_PATH := "user://endings.json"
const CATALOG := [
	"ENTREGA ABANDONADA", "DESTINO NÃO ENCONTRADO", "VISITANTE RETIRADO",
	"PIZZA APREENDIDA", "ACESSO NÃO AUTORIZADO", "IDENTIDADE FALSIFICADA",
	"INOVAÇÃO DEMAIS", "ENTREGA POR ENCANAMENTO", "REUNIÃO RECORRENTE",
	"INCIDENTE DE SEGURANÇA", "PIZZA AS A SERVICE", "ENTREGA DIGITALMENTE CONCLUÍDA",
	"MENOR PREÇO", "FORNECEDOR HOMOLOGADO", "CADASTRO EM ANÁLISE", "MATERIAL RETIDO",
	"PIZZA SOB CUSTÓDIA FISCAL", "FALHA ESTRUTURAL", "PIZZA EM QUARENTENA",
	"ÁREA RESTRITA", "PROMOVIDO A TERCEIRIZADO", "DEMITIDO ANTES DE SER CONTRATADO",
	"EFETIVADO POR ENGANO", "LI E ACEITO", "EM ANÁLISE", "DIRETOR DESCONHECIDO",
	"PIZZA FRIA", "ENTREGA TARDE DEMAIS", "SEM PIZZA", "ENTREGA CONCLUÍDA"
]

var seen: Array = []

func _ready() -> void:
	_load_data()

func register(name: String) -> void:
	if name not in CATALOG:
		return
	if name not in seen:
		seen.append(name)
		_save_data()
	ending_registered.emit(name)

func _save_data() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(seen))

func _load_data() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		return
	var parsed = JSON.parse_string(file.get_as_text())
	if parsed is Array:
		seen = parsed
