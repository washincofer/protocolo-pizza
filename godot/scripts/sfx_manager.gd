extends Node
var player: AudioStreamPlayer
var inventory_size: int = 0
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	player = AudioStreamPlayer.new()
	add_child(player)
	GameState.changed.connect(_on_changed)
	GameFlow.finished.connect(func(_name: String,_text: String): play_tone(220))
	AchievementManager.achievement_unlocked.connect(func(_name: String): play_tone(880))
func _on_changed() -> void:
	if GameState.inventory.size() > inventory_size: play_tone(660)
	inventory_size = GameState.inventory.size()
func play_tone(frequency: float) -> void:
	var volume: float = float(SettingsManager.get_value("sfx_volume",0.85))
	if volume <= 0.001: return
	var data: PackedByteArray = PackedByteArray()
	data.resize(13230)
	for i: int in range(6615): data.encode_s16(i*2,int(sin(TAU*frequency*i/44100.0)*sin(PI*i/6615)*9000))
	var stream: AudioStreamWAV = AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = 44100
	stream.data = data
	player.volume_db = linear_to_db(volume)
	player.stream = stream
	player.play()
func _exit_tree() -> void:
	if is_instance_valid(player):
		player.stop()
		player.stream = null
