extends Node

var current_scene: String = "reception"
var inventory: Array[String] = []
var knowledge: Array[String] = []
var flags: Dictionary = {}
var disguise: String = ""
var achievements: Array[String] = []

var pizza := {
	"temperature": 100,
	"integrity": 100,
	"quantity": 8,
	"elapsed_minutes": 0,
	"possession": "player"
}

func has_item(item_id: String) -> bool:
	return item_id in inventory

func learn(knowledge_id: String) -> void:
	if knowledge_id not in knowledge:
		knowledge.append(knowledge_id)

func set_flag(flag_id: String, value = true) -> void:
	flags[flag_id] = value
