extends Node

signal settings_changed

const SAVE_PATH := "user://settings.json"
var settings := {
	"master_volume": 0.85,
	"music_volume": 0.75,
	"sfx_volume": 0.85,
	"fullscreen": false
}

func _ready() -> void:
	_load_data()
	apply()

func set_value(key: String, value) -> void:
	settings[key] = value
	apply()
	_save_data()
	settings_changed.emit()

func get_value(key: String, fallback = null):
	return settings.get(key, fallback)

func apply() -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(max(float(settings.get("master_volume", 0.85)), 0.001)))
	var music_bus := AudioServer.get_bus_index("Music")
	if music_bus >= 0:
		AudioServer.set_bus_volume_db(music_bus, linear_to_db(max(float(settings.get("music_volume", 0.75)), 0.001)))
	var sfx_bus := AudioServer.get_bus_index("SFX")
	if sfx_bus >= 0:
		AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(max(float(settings.get("sfx_volume", 0.85)), 0.001)))
	var desired_mode := DisplayServer.WINDOW_MODE_FULLSCREEN if bool(settings.get("fullscreen", false)) else DisplayServer.WINDOW_MODE_WINDOWED
	if DisplayServer.window_get_mode() != desired_mode:
		DisplayServer.window_set_mode(desired_mode)

func _save_data() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(settings))

func _load_data() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		return
	var parsed = JSON.parse_string(file.get_as_text())
	if parsed is Dictionary:
		for key in parsed.keys():
			settings[key] = parsed[key]
