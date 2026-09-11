extends Node

signal area_changed(area_id: String)

func route_to(area_id: String) -> void:
	if area_id.is_empty():
		return
	if SceneTransition.is_transitioning():
		return
	SceneTransition.transition_to(area_id, Callable(self, "_commit_route"))

func _commit_route(area_id: String) -> void:
	GameState.current_area = area_id
	GameState.changed.emit()
	area_changed.emit(area_id)
