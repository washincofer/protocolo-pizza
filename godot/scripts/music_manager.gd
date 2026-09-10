extends Node

const MENU_AUDIO_PATH: String = "res://assets/audio/menu_intro.ogg"
const RECEPTION_AUDIO_PATH: String = "res://assets/audio/reception_theme.ogg"
const MENU_IMAGE_SUFFIX: String = "/assets/scenarios/menu.png"
const CHECK_INTERVAL: float = 0.25
const FADE_IN_SECONDS: float = 0.8
const FADE_OUT_SECONDS: float = 0.45
const SILENT_DB: float = -50.0

const RECEPTION_AREAS: Array[String] = [
	"reception",
	"reception_waiting_room",
	"reception_auditorium"
]

var player: AudioStreamPlayer
var fade_tween: Tween
var check_accumulator: float = 0.0
var requested_mode: String = ""
var current_mode: String = ""

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	player = AudioStreamPlayer.new()
	player.name = "MusicPlayer"
	player.process_mode = Node.PROCESS_MODE_ALWAYS
	player.volume_db = SILENT_DB
	add_child(player)
	if SettingsManager.has_signal("settings_changed"):
		SettingsManager.settings_changed.connect(_apply_music_volume)
	set_process(true)
	set_process_input(true)

func _process(delta: float) -> void:
	check_accumulator += delta
	if check_accumulator < CHECK_INTERVAL:
		return
	check_accumulator = 0.0
	var desired_mode: String = _desired_mode()
	if desired_mode == requested_mode:
		return
	requested_mode = desired_mode
	_switch_to_requested_mode()

func _input(event: InputEvent) -> void:
	if requested_mode.is_empty() or player.playing:
		return
	var pressed: bool = false
	if event is InputEventMouseButton:
		pressed = (event as InputEventMouseButton).pressed
	elif event is InputEventKey:
		pressed = (event as InputEventKey).pressed
	if pressed:
		_start_requested_stream()

func _desired_mode() -> String:
	if _menu_is_visible():
		return "menu"
	if not GameState.run_active:
		return ""
	if GameState.current_area in RECEPTION_AREAS:
		return "reception"
	return ""

func _menu_is_visible() -> bool:
	var current: Node = get_tree().current_scene
	if current == null:
		return false
	for child: Node in current.get_children():
		if child is TextureRect:
			var rect: TextureRect = child as TextureRect
			if rect.texture == null:
				continue
			var path: String = rect.texture.resource_path
			if path.ends_with(MENU_IMAGE_SUFFIX) or path.ends_with("/menu.png"):
				return true
	return false

func _track_path(mode: String) -> String:
	match mode:
		"menu":
			return MENU_AUDIO_PATH
		"reception":
			return RECEPTION_AUDIO_PATH
		_:
			return ""

func _switch_to_requested_mode() -> void:
	if requested_mode.is_empty():
		_fade_out_and_stop()
		return
	if current_mode == requested_mode and player.playing:
		_fade_to(_music_target_db(), FADE_IN_SECONDS)
		return
	if player.playing:
		_kill_tween()
		fade_tween = create_tween()
		fade_tween.tween_property(player, "volume_db", SILENT_DB, FADE_OUT_SECONDS)
		fade_tween.tween_callback(_start_requested_stream)
	else:
		_start_requested_stream()

func _start_requested_stream() -> void:
	var path: String = _track_path(requested_mode)
	if path.is_empty() or not ResourceLoader.exists(path):
		player.stop()
		current_mode = ""
		return
	var resource: Resource = load(path)
	if not (resource is AudioStream):
		return
	var stream: AudioStream = resource as AudioStream
	if stream is AudioStreamOggVorbis:
		(stream as AudioStreamOggVorbis).loop = true
	player.stop()
	player.stream = stream
	player.volume_db = SILENT_DB
	player.play()
	current_mode = requested_mode
	_fade_to(_music_target_db(), FADE_IN_SECONDS)

func _fade_out_and_stop() -> void:
	current_mode = ""
	if not player.playing:
		return
	_kill_tween()
	fade_tween = create_tween()
	fade_tween.tween_property(player, "volume_db", SILENT_DB, FADE_OUT_SECONDS)
	fade_tween.tween_callback(player.stop)

func _apply_music_volume() -> void:
	if player.playing:
		_fade_to(_music_target_db(), 0.15)

func _music_target_db() -> float:
	var volume: float = float(SettingsManager.get_value("music_volume", 0.75))
	if volume <= 0.001:
		return SILENT_DB
	return linear_to_db(volume)

func _fade_to(target_db: float, seconds: float) -> void:
	_kill_tween()
	fade_tween = create_tween()
	fade_tween.tween_property(player, "volume_db", target_db, seconds)

func _kill_tween() -> void:
	if fade_tween != null and fade_tween.is_valid():
		fade_tween.kill()
	fade_tween = null
