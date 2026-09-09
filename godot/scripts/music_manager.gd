extends Node

const MENU_AUDIO_PATH := "res://assets/audio/menu_intro.ogg"
const MENU_IMAGE_SUFFIX := "/assets/scenarios/menu.png"
const CHECK_INTERVAL := 0.25
const FADE_IN_SECONDS := 0.8
const FADE_OUT_SECONDS := 0.6
const SILENT_DB := -50.0

var player: AudioStreamPlayer
var fade_tween: Tween
var check_accumulator := 0.0
var menu_requested := false
var current_mode := ""

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	player = AudioStreamPlayer.new()
	player.name = "MenuMusicPlayer"
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
	var should_play_menu := _menu_is_visible()
	if should_play_menu:
		if current_mode != "menu":
			current_mode = "menu"
			play_menu()
	elif current_mode == "menu":
		current_mode = "game"
		stop_music()

func _input(event: InputEvent) -> void:
	if not menu_requested or player.playing:
		return
	var pressed := false
	if event is InputEventMouseButton:
		pressed = (event as InputEventMouseButton).pressed
	elif event is InputEventKey:
		pressed = (event as InputEventKey).pressed
	if pressed:
		_start_menu_stream()

func _menu_is_visible() -> bool:
	var current := get_tree().current_scene
	if current == null:
		return false
	for child in current.get_children():
		if child is TextureRect:
			var rect := child as TextureRect
			if rect.texture == null:
				continue
			var path := rect.texture.resource_path
			if path.ends_with(MENU_IMAGE_SUFFIX) or path.ends_with("/menu.png"):
				return true
	return false

func play_menu() -> void:
	menu_requested = true
	if player.playing:
		_fade_to(_music_target_db(), FADE_IN_SECONDS)
		return
	_start_menu_stream()

func _start_menu_stream() -> void:
	if not menu_requested:
		return
	if not ResourceLoader.exists(MENU_AUDIO_PATH):
		return
	var stream := load(MENU_AUDIO_PATH)
	if stream == null:
		return
	if stream is AudioStreamOggVorbis:
		(stream as AudioStreamOggVorbis).loop = true
	player.stream = stream
	player.volume_db = SILENT_DB
	player.play()
	_fade_to(_music_target_db(), FADE_IN_SECONDS)

func stop_music(fade_seconds: float = FADE_OUT_SECONDS) -> void:
	menu_requested = false
	if not player.playing:
		return
	_kill_tween()
	fade_tween = create_tween()
	fade_tween.tween_property(player, "volume_db", SILENT_DB, fade_seconds)
	fade_tween.tween_callback(player.stop)

func _apply_music_volume() -> void:
	if player.playing and menu_requested:
		_fade_to(_music_target_db(), 0.15)

func _music_target_db() -> float:
	var volume := float(SettingsManager.get_value("music_volume", 0.75))
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
