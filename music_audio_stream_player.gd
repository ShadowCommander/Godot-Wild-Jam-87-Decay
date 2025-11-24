extends AudioStreamPlayer

const ZERO_VOLUME: int = -40

@export var transition: float
var previous_music: int = -1
var target_music: int = -1

const QUIET: int = 0
const WAVE: int = 1

func _on_wave_system_prep() -> void:
	volume_db = -20
	transition_index(QUIET)
	create_tween().tween_property(self, "volume_db", -10, 6)

func _on_wave_system_wave_begin() -> void:
	transition_index(WAVE)

func _on_wave_system_wave_end() -> void:
	transition_index(QUIET)

func transition_index(music_index: int) -> void:
	previous_music = target_music
	target_music = music_index
	transition = 0

var time: float = 0
var transition_time: float = 6.0

func _physics_process(delta: float) -> void:
	time += delta

	var r = min(time / transition_time, transition_time)
	var s: AudioStreamSynchronized = stream as AudioStreamSynchronized
	if previous_music != -1:
		s.set_sync_stream_volume(previous_music, min(ZERO_VOLUME + (1.0 - r) * (-ZERO_VOLUME), 0.0))
	if target_music != -1:
		s.set_sync_stream_volume(target_music, min(ZERO_VOLUME + r * (-ZERO_VOLUME), 0.0))
	print("Target music: %d, volume: %d. Other volume: %d" % [target_music, min(ZERO_VOLUME + r * (-ZERO_VOLUME), 0.0), min(ZERO_VOLUME + (1.0 - r) * (-ZERO_VOLUME), 0.0)])
