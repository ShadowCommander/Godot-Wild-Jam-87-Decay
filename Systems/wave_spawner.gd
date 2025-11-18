class_name WaveSpawner extends Node


@export var pool: NodePool
@export var spawn_delay: float = 1:
	set(value):
		wave_timer.set_wait_time(value)
@export var wave_spawn_count: int = 5
var spawn_radius: float = 5

var spawn_points: Array

var wave_timer: Timer = Timer.new()

func _ready() -> void:
	spawn_points = get_children().filter(func(n): return n is Marker3D)
	assert(len(spawn_points) != 0, "There must be at least one spawn point.")
	assert(pool, "WaveSpawner requires a NodePool")
	
	wave_timer.autostart = true
	add_child(wave_timer)
	wave_timer.timeout.connect(spawn_wave.bind(5))
	
	
	pass


# Spawns n amount of an enemy
func spawn_wave(n: int) -> void:
	for _i in range(n):
		var o = pool.get_pooled() as BaseMonster
		
		var rdm_spawn_point: SpawnPoint =\
		spawn_points[randi() % spawn_points.size()]
		
		o.global_transform.origin = get_spawn_position(rdm_spawn_point)
		o.target = rdm_spawn_point.target_wall
		
	pass




# Gets a random spawn position aligned to a cardinal direction grid.
func get_spawn_position(spawn_point: SpawnPoint) -> Vector3:
	var origin: Vector3 = spawn_point.global_transform.origin
	
	var dir_to_center: Vector3 = snap_to_grid(origin.normalized())
	
	var left = Vector3.UP.cross(dir_to_center) * randf_range(-spawn_radius,spawn_radius)
	var right = dir_to_center.cross(Vector3.UP) * randf_range(-spawn_radius,spawn_radius)
	
	var offset: Vector3 = Vector3.UP
	
	if randi() % 2:
		offset += left
	else:
		offset += right
	
	var spawn_position: Vector3 = origin + offset
	return spawn_position

# Snaps a Vector3 direction to either left, right, forward or back.
# This returns Vector3.ZERO if somehow that is passed in but I'm not handling
# if that actually happens anywhere.
func snap_to_grid(dir: Vector3) -> Vector3:
	dir.y = 0
	
	if dir == Vector3.ZERO:
		return Vector3.ZERO
	
	return Vector3(sign(dir.x), 0,0) if abs(dir.x) > abs(dir.z) else Vector3(0,0,sign(dir.z))


func _on_wall_dead_wall() -> void:
	wave_timer.stop()
	pass # Replace with function body.
