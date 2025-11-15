extends CharacterBody3D

const CAMERA_X_ROT_MIN := deg_to_rad(-90)
const CAMERA_X_ROT_MAX := deg_to_rad(90)

@export_category("Config")
@export var look_relative: GUIDEAction
@export var movement: GUIDEAction

@export var yaw_pivot: Node3D
@export var pitch_pivot: Node3D

@export_category("Stats")
@export var speed: float = 10.0

func _ready() -> void:
	look_relative.triggered.connect(on_look_relative)

func _physics_process(delta: float) -> void:
	process_movement(delta)
	
#region Movement

func process_movement(delta: float) -> void:
	var input = movement.value_axis_2d.normalized()
	var movement_z = yaw_pivot.basis.z * -input.y
	var movement_x = yaw_pivot.basis.x * input.x
	var movement = (movement_z + movement_x) * speed
	velocity = movement
	move_and_slide()

#endregion

#region Camera

func on_look_relative() -> void:
	rotate_camera(look_relative.value_axis_2d)

func rotate_camera(move):
	yaw_pivot.rotate_y(-move.x)
	# After relative transforms, camera needs to be renormalized.
	#camera_base.orthonormalize()
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x - move.y, CAMERA_X_ROT_MIN, CAMERA_X_ROT_MAX)
	#camera_moved.emit()

#endregion
