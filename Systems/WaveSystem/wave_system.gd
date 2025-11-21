extends Node

# 2-3 minute wave
# 1-2 minute break
# 


func _ready() -> void:
	assert(enemy_spawner != null, "enemy_spawner is not set. %s" % get_path())
	begin_prep()

@export_category("Settings")
@export var wave_count = 0

@export var prep_time: float = 10
@export var wave_time: float = 30
@export var break_time: float = 10

@export var waves: Array[WaveData] = []

@export_category("Nodes")
@export var enemy_spawner: WaveSpawner


func begin_prep() -> void:
	print("Starting prep. Waiting: %s" % prep_time)
	var timer = get_tree().create_timer(prep_time, false, true)
	timer.timeout.connect(begin_wave)

func begin_wave() -> void:
	print("Starting wave. Waiting: %s" % wave_time)
	var timer = get_tree().create_timer(wave_time, false, true)
	timer.timeout.connect(end_wave)
	
	var data: WaveData = waves[wave_count]
	enemy_spawner.start_spawning(data)
	
func end_wave() -> void:
	print("Starting break. Waiting: %s" % break_time)
	
	var data: WaveData = waves[wave_count]
	
	if wave_count >= waves.size() - 1:
		print("No more rounds. Win?")
		if not data.infinite:
			enemy_spawner.stop_spawning()
			return
	else:
		wave_count += 1
	
	enemy_spawner.stop_spawning()
	
	var timer = get_tree().create_timer(break_time, false, true)
	timer.timeout.connect(begin_wave)
