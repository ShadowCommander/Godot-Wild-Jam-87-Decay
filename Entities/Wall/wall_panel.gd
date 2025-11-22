extends RigidBody3D

var sleep_delay: int = 2000
var touching: Dictionary[RID, int] = {}

func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	touching[body_rid] = Time.get_ticks_msec() + sleep_delay

func _on_body_shape_exited(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	touching.erase(body_rid)

func _physics_process(delta: float) -> void:
	return
	if sleeping:
		return
	if angular_velocity.length_squared() >= 0.5:
		return
	if linear_velocity.length_squared() >= 0.5:
		return
	for rid in touching:
		if Time.get_ticks_msec() > touching[rid]:
			lock_rotation = true
			await get_tree().create_timer(0.1, false, true).timeout
			lock_rotation = false
