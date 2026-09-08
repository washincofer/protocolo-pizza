extends Node

signal achievement_unlocked(name: String)

const SAVE_PATH := "user://achievements.json"
const CATALOG := [
	"Nem iniciou o jogo", "O palestrante atrasado", "Uma palestra de sucesso",
	"Primeiro processo contornado", "Weekly eterna", "Pizza as a Service",
	"Compra emergencial", "Economia de R$ 2", "Importação Irregular",
	"Dados Protegidos", "Logística Reversa", "Passou na cara dura",
	"Agora eu trabalho aqui", "Big Brother Corporativo", "Amostragem destrutiva",
	"Experiência profissional de 0 dias", "Contratado sem entrevista",
	"Termos e Condições", "Ainda esperando", "Agora fiquei mais perdido",
	"PROTOCOLO: PIZZA", "100% Conforme"
]

var unlocked_names: Array = []

func _ready() -> void:
	_load_data()

func unlock(name: String) -> void:
	if name not in CATALOG or name in unlocked_names:
		return
	unlocked_names.append(name)
	_save_data()
	achievement_unlocked.emit(name)
	if name != "100% Conforme" and _base_achievement_count() >= 21:
		unlock("100% Conforme")

func is_unlocked(name: String) -> bool:
	return name in unlocked_names

func _base_achievement_count() -> int:
	var total := 0
	for i in range(21):
		if CATALOG[i] in unlocked_names:
			total += 1
	return total

func _save_data() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(unlocked_names))

func _load_data() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		return
	var parsed = JSON.parse_string(file.get_as_text())
	if parsed is Array:
		unlocked_names = parsed
