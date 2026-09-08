extends Node

const SAVE_VERSION := 1

func _slot_path(slot: int) -> String:
	return "user://save_%d.json" % slot

func has_slot(slot: int) -> bool:
	return FileAccess.file_exists(_slot_path(slot))

func save_slot(slot: int) -> bool:
	if not GameState.run_active:
		return false
	var payload := {
		"version": SAVE_VERSION,
		"meta": {
			"saved_at": Time.get_datetime_string_from_system(),
			"area": GameState.current_area,
			"minutes": int(GameState.pizza.get("elapsed_minutes", 0))
		},
		"state": GameState.to_dict()
	}
	var file := FileAccess.open(_slot_path(slot), FileAccess.WRITE)
	if not file:
		return false
	file.store_string(JSON.stringify(payload))
	return true

func load_slot(slot: int) -> bool:
	if not has_slot(slot):
		return false
	var file := FileAccess.open(_slot_path(slot), FileAccess.READ)
	if not file:
		return false
	var parsed = JSON.parse_string(file.get_as_text())
	if not (parsed is Dictionary):
		return false
	var state = parsed.get("state", {})
	if not (state is Dictionary):
		return false
	GameState.restore(state)
	return true

func get_slot_metadata(slot: int) -> Dictionary:
	if not has_slot(slot):
		return {}
	var file := FileAccess.open(_slot_path(slot), FileAccess.READ)
	if not file:
		return {}
	var parsed = JSON.parse_string(file.get_as_text())
	if parsed is Dictionary:
		var meta = parsed.get("meta", {})
		if meta is Dictionary:
			return meta
	return {}

func delete_slot(slot: int) -> void:
	var path := _slot_path(slot)
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
