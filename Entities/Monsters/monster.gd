class_name BaseMonster extends Node3D

const MIN_DISTANCE: float = 2.5
const radius: float = 3.0

@export var health_component: HealthComponent
@export var hurtbox_component: Hurtbox
@export var attack_timer: Timer
@export var ATK_DAMAGE: int = 700

@export_range(1.0,40.0) var MOVEMENT_SPEED: float = 1.0


var moving_direction: Vector3
var final_pos: Vector3 

class SpawnData:
	var spawn_marker: SpawnPoint = null
	var target: Wall  = null
	func _init(s: SpawnPoint, t: Wall) -> void:
		spawn_marker = s
		target = t
		pass
	pass


var spawn_info: SpawnData = null:
	set(new_value):
		if new_value == null:
			spawn_info = new_value
			return
		
		spawn_info = new_value
		
		var origin: Vector3 = global_transform.origin
		var spawn_pos: Vector3 = spawn_info.spawn_marker.global_transform.origin
		var target_pos: Vector3 = spawn_info.target.global_transform.origin
		
		var offset: Vector3 = Helpers.flatten(origin) - (Helpers.flatten(spawn_pos))
		
		final_pos = Helpers.flatten(target_pos) + offset
		moving_direction = Helpers.flatten(origin).direction_to(final_pos)
		
		pass


func _ready() -> void:
	if health_component:
		health_component.health_changed.connect(_on_health_changed)
	if attack_timer:
		attack_timer.timeout.connect(_start_attack)
	pass


func _physics_process(delta: float) -> void:
	if not spawn_info:
		return
	
	var dis: float = Helpers.flatten(global_transform.origin).distance_squared_to(final_pos)
	
	if dis > MIN_DISTANCE:
		_move(moving_direction, delta)
	else:
		if attack_timer.is_stopped():
			attack_timer.start()
	pass


func _start_attack():
	_attack()
	attack_timer.start()
	pass


func _attack():
	if not spawn_info:
		return
	
	if spawn_info.target and spawn_info.target.has_method("get_health_component"):
		var h: HealthComponent = spawn_info.target.get_health_component()
		h.take_damage(ATK_DAMAGE)
	pass


func _move(movement_vector: Vector3, delta: float):
	global_transform.origin += movement_vector * delta * MOVEMENT_SPEED
	pass


func _on_health_changed(health: int):
	# Death
	if health <= 0:
		emit_signal("return_to_pool", self)
		health_component.reset()
		spawn_info = null
	pass


func enable_components(b: bool):
	hurtbox_component.set_monitorable.call_deferred(b)
	pass

func snap_to_grid(dir: Vector3) -> Vector3:
	dir.y = 0
	
	if dir == Vector3.ZERO:
		return Vector3.ZERO
	
	return Vector3(sign(dir.x), 0,0) if abs(dir.x) > abs(dir.z) else Vector3(0,0,sign(dir.z))
