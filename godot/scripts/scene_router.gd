extends Node

signal area_changed(area_id: String)

func route_to(area_id: String) -> void:
	if not preload("res://scripts/hotspot_catalog.gd").BACKGROUNDS.has(area_id) or area_id == "menu": return
	PlayerController.cancel_movement()
	GameState.current_area = area_id
	GameState.changed.emit()
	area_changed.emit(area_id)
