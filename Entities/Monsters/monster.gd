class_name BaseMonster extends Node3D

const MIN_DISTANCE: float = 1.5


@export var health_component: HealthComponent
@export_range(1.0,5.0) var MOVEMENT_SPEED: float = 1.0

var player = null # Just to prevent having to find it in the tree every call.

func _ready() -> void:
	
	if health_component:
		health_component.health_changed.connect(_on_health_changed)
	
	pass

func _physics_process(delta: float) -> void:
	
	var origin: Vector3 = Helpers.flatten(global_transform.origin)
	var player_pos: Vector3 = Helpers.flatten(get_player_position())
	
	var dir: Vector3 = origin.direction_to(player_pos)
	var dis: float = origin.distance_squared_to(player_pos)
	
	if dis > MIN_DISTANCE:
		_move(dir, delta)
	
	
	pass


func get_player_position() -> Vector3:
	if not player: player = get_tree().get_first_node_in_group("player_body")
	var p_pos: Vector3 = player.global_transform.origin if player else Vector3.ZERO 
	return p_pos

func _move(movement_vector: Vector3, delta: float):
	global_transform.origin += movement_vector * delta * MOVEMENT_SPEED
	pass

func _on_health_changed(health: int):
	# Death
	if health <= 0:
		emit_signal("return_to_pool", self)
		health_component.reset()
	
	pass
