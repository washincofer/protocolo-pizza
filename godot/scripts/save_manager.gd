extends Node
const SAVE_VERSION: int = 2
const Hotspots = preload("res://scripts/hotspot_catalog.gd")
const ITEMS: Array[String] = ["visitor_badge","vr_glasses","executive_priority_stamp","third_party_proof","fiscal_exception_protocol","maintenance_vest","work_order","third_party_form","rh_validation_signature","legal_bolota_pending","legal_bolota_approved"]
var last_error: String = ""
func _slot_path(slot: int) -> String:
	return "user://save_%d.json" % slot
func has_slot(slot: int) -> bool:
	return not get_slot_metadata(slot).is_empty()
func checkpoint() -> void:
	if GameState.run_active: save_slot(0)
func save_slot(slot: int) -> bool:
	last_error = ""
	if not GameState.run_active:
		last_error = "Não há entrega em andamento."
		return false
	var payload: Dictionary = {"version":SAVE_VERSION,"meta":{"saved_at":Time.get_datetime_string_from_system(),"area":GameState.current_area,"minutes":GameState.pizza.get("elapsed_minutes",0)},"state":GameState.to_dict(),"player":PlayerController.snapshot(),"dialogue":DialogueUI.snapshot()}
	var path: String = _slot_path(slot)
	var file: FileAccess = FileAccess.open(path + ".tmp",FileAccess.WRITE)
	if file == null:
		last_error = "Não foi possível gravar a partida."
		return false
	file.store_string(JSON.stringify(payload))
	file.flush()
	var error: Error = file.get_error()
	file.close()
	if error != OK or _read_valid(path + ".tmp").is_empty():
		last_error = "A gravação falhou. A partida anterior foi preservada."
		return false
	if not _read_valid(path).is_empty() and DirAccess.copy_absolute(path,path+".bak") != OK:
		last_error = "Não foi possível preservar o backup."
		return false
	if DirAccess.rename_absolute(path+".tmp",path) != OK:
		last_error = "Não foi possível concluir a gravação."
		return false
	return true
func load_slot(slot: int) -> bool:
	last_error = ""
	var payload: Dictionary = _read_valid(_slot_path(slot))
	if payload.is_empty():
		payload = _read_valid(_slot_path(slot)+".bak")
		if payload.is_empty():
			last_error = "Partida inválida ou incompatível. A sessão atual foi preservada."
			return false
		last_error = "Partida recuperada do backup."
	MenuUI.close_all()
	UIPolish._close_pause()
	UIPolish._close_inventory()
	ExperienceUI.close()
	DialogueUI.close_dialogue()
	DialogueUI.close_speech()
	PlayerController.cancel_movement()
	GameState.restore(payload["state"])
	PlayerController.restore_snapshot(payload.get("player",{}))
	var main: Node = get_tree().current_scene
	if main != null:
		main.set("selected_item", "")
		main.set("feedback_text", "Partida carregada.")
	SceneRouter.area_changed.emit(GameState.current_area)
	DialogueUI.call_deferred("restore_snapshot",payload.get("dialogue",{}))
	return true
func _read_valid(path: String) -> Dictionary:
	if not FileAccess.file_exists(path): return {}
	var file: FileAccess = FileAccess.open(path,FileAccess.READ)
	if file == null: return {}
	var parser: JSON = JSON.new()
	var error: Error = parser.parse(file.get_as_text())
	file.close()
	if error != OK or not (parser.data is Dictionary) or not _valid_payload(parser.data): return {}
	return parser.data
func _numeric(value: Variant) -> bool:
	return (value is int or value is float) and is_finite(float(value))
func _valid_payload(payload: Dictionary) -> bool:
	var version: Variant = payload.get("version")
	if not _numeric(version) or float(version) != int(version) or int(version) not in [1,2]: return false
	var state: Variant = payload.get("state")
	if not (state is Dictionary): return false
	if not (state.get("current_area") is String) or not Hotspots.BACKGROUNDS.has(state["current_area"]) or state["current_area"] == "menu": return false
	if not (state.get("run_active") is bool) or not state["run_active"]: return false
	if not (state.get("inventory") is Array) or not (state.get("knowledge") is Array) or not (state.get("flags") is Dictionary) or not (state.get("pizza") is Dictionary): return false
	for item: Variant in state["inventory"]:
		if not (item is String) or item not in ITEMS: return false
	for item: Variant in state["knowledge"]:
		if not (item is String): return false
	for key: Variant in state["flags"]:
		if not (key is String) or not (state["flags"][key] is bool or state["flags"][key] is String or _numeric(state["flags"][key])): return false
	if not (state.get("player_name", "") is String) or state.get("disguise", "") not in ["","maintenance"]: return false
	var pizza: Dictionary = state["pizza"]
	for key: String in ["temperature","integrity","quantity","elapsed_minutes"]:
		if not _numeric(pizza.get(key)) or float(pizza[key]) < 0: return false
	if float(pizza["temperature"]) > 100 or float(pizza["integrity"]) > 100 or float(pizza["quantity"]) > 8 or pizza.get("possession") not in ["player","lost","confiscated"]: return false
	var player: Variant = payload.get("player",{})
	if not (player is Dictionary): return false
	if not player.is_empty():
		if player.get("area") != state["current_area"]: return false
		var pos: Variant = player.get("position")
		if not (pos is Array) or pos.size() != 2: return false
		if not _numeric(pos[0]) or not _numeric(pos[1]) or float(pos[0]) < 0 or float(pos[0]) > 1672 or float(pos[1]) < 0 or float(pos[1]) > 941: return false
		if player.get("direction") not in ["up","down","left","right"]: return false
	var history: Variant = state.get("dialogue_history",[])
	if not (history is Array) or history.size() > 120: return false
	for entry: Variant in history:
		if not (entry is Dictionary): return false
		for key: String in ["speaker","text","area"]:
			if not (entry.get(key) is String): return false
	return DialogueUI.valid_snapshot(payload.get("dialogue",{}))
func get_slot_metadata(slot: int) -> Dictionary:
	var payload: Dictionary = _read_valid(_slot_path(slot))
	if payload.is_empty(): payload = _read_valid(_slot_path(slot)+".bak")
	var meta: Variant = payload.get("meta",{})
	return meta if meta is Dictionary else {}
func delete_slot(slot: int) -> void:
	for suffix: String in ["",".bak",".tmp"]:
		if FileAccess.file_exists(_slot_path(slot)+suffix): DirAccess.remove_absolute(_slot_path(slot)+suffix)
