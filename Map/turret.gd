extends Node3D

@export var pivot: Node3D

var targets: Dictionary = {}

func _on_enemy_detection_area_area_shape_entered(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int) -> void:
	targets[area_rid] = area

func _on_enemy_detection_area_area_shape_exited(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int) -> void:
	targets.erase(area_rid)

# Fire at target until dead
# Turn to enemy that takes the least amount of rotation.

# Preditive targeting
var old_target_pos: Vector3

func _physics_process(delta: float) -> void:
	shoot()

func shoot() -> void:
	if targets.size() <= 0:
		return
	var target: Node3D = null
	for area in targets:
		if target == null:
			target = targets[area]
	aim_at_target(target)
	
func aim_at_target(target: Node3D) -> void:
	pivot.look_at(target.global_position)


func point_at_position(target: Vector3) -> void:
	var target_direction_vector: Vector3 = target - global_position
	#yaw_pivot.rotation.y = atan2(target_direction_vector)
