extends Node

signal area_changed(area_id: String)

func route_to(area_id: String) -> void:
	GameState.current_area = area_id
	GameState.changed.emit()
	area_changed.emit(area_id)
