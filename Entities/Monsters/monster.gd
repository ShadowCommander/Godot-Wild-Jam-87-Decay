class_name BaseMonster extends Node3D

const MIN_DISTANCE: float = 2.5


@export var health_component: HealthComponent
@export_range(1.0,5.0) var MOVEMENT_SPEED: float = 1.0

# Monsters need a wall to target and will not 
var target: Wall = null 


func _ready() -> void:
	
	if health_component:
		health_component.health_changed.connect(_on_health_changed)
	
	pass

func _physics_process(delta: float) -> void:
	if not target:
		return
	
	var origin: Vector3 = global_transform.origin
	var dir: Vector3 = origin.direction_to(target.global_transform.origin)
	var dis: float = origin.distance_squared_to(target.global_transform.origin)
	
	if dis > MIN_DISTANCE:
		_move(dir, delta)
	else:
		if target and target.has_method("get_health_component"):
			var h: HealthComponent = target.get_health_component()
			h.take_damage(1)
	
	
	pass


func _move(movement_vector: Vector3, delta: float):
	global_transform.origin += movement_vector * delta * MOVEMENT_SPEED
	pass


func _on_health_changed(health: int):
	# Death
	if health <= 0:
		emit_signal("return_to_pool", self)
		health_component.reset()
	
	pass
