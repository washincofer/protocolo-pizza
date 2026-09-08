extends Node

signal changed

var run_active := false
var current_area := "reception"
var inventory: Array = []
var knowledge: Array = []
var flags: Dictionary = {}
var disguise := ""
var player_name := ""
var pizza: Dictionary = {}

func _ready() -> void:
	reset_run(false)

func reset_run(mark_active: bool = true) -> void:
	run_active = mark_active
	current_area = "reception"
	inventory = []
	knowledge = []
	flags = {}
	disguise = ""
	player_name = ""
	pizza = {
		"temperature": 100,
		"integrity": 100,
		"quantity": 8,
		"elapsed_minutes": 0,
		"possession": "player"
	}
	changed.emit()

func has_item(item_id: String) -> bool:
	return item_id in inventory

func add_item(item_id: String) -> void:
	if item_id not in inventory:
		inventory.append(item_id)
		changed.emit()

func remove_item(item_id: String) -> void:
	if item_id in inventory:
		inventory.erase(item_id)
		changed.emit()

func knows(knowledge_id: String) -> bool:
	return knowledge_id in knowledge

func learn(knowledge_id: String) -> void:
	if knowledge_id not in knowledge:
		knowledge.append(knowledge_id)
		changed.emit()

func set_flag(flag_id: String, value = true) -> void:
	flags[flag_id] = value
	changed.emit()

func has_flag(flag_id: String) -> bool:
	return bool(flags.get(flag_id, false))

func equip_disguise(disguise_id: String) -> void:
	disguise = disguise_id
	changed.emit()

func tick(minutes: int = 5) -> void:
	pizza["elapsed_minutes"] = int(pizza.get("elapsed_minutes", 0)) + minutes
	var drop := max(1, int(ceil(float(minutes) * 0.6)))
	pizza["temperature"] = clamp(int(pizza.get("temperature", 100)) - drop, 0, 100)
	changed.emit()

func to_dict() -> Dictionary:
	return {
		"run_active": run_active,
		"current_area": current_area,
		"inventory": inventory.duplicate(true),
		"knowledge": knowledge.duplicate(true),
		"flags": flags.duplicate(true),
		"disguise": disguise,
		"player_name": player_name,
		"pizza": pizza.duplicate(true)
	}

func restore(data: Dictionary) -> void:
	run_active = bool(data.get("run_active", true))
	current_area = str(data.get("current_area", "reception"))
	inventory = data.get("inventory", []).duplicate(true)
	knowledge = data.get("knowledge", []).duplicate(true)
	flags = data.get("flags", {}).duplicate(true)
	disguise = str(data.get("disguise", ""))
	player_name = str(data.get("player_name", ""))
	pizza = data.get("pizza", {}).duplicate(true)
	if pizza.is_empty():
		pizza = {"temperature":100,"integrity":100,"quantity":8,"elapsed_minutes":0,"possession":"player"}
	changed.emit()
