extends CharacterBody3D

const CAMERA_X_ROT_MIN := deg_to_rad(-90)
const CAMERA_X_ROT_MAX := deg_to_rad(90)
@onready var footsteps: FmodEventEmitter3D = $Footsteps
@onready var foot_step_timer: Timer = $FootStepTimer
@onready var shoot_sound: FmodEventEmitter3D = $ShootSound

#var was_moving := false

@export_category("Config")
@export var look_relative: GUIDEAction
@export var movement: GUIDEAction

@export var yaw_pivot: Node3D
@export var pitch_pivot: Node3D

@export_category("Stats")
@export var speed: float = 10.0


func _ready() -> void:
	look_relative.triggered.connect(on_look_relative)
	var children = get_children()
	var components = children.filter(func(child): return child is Component)
	for child: Component in components:
		child.entity = self
		child.setup_signals_on_parent()
	for child: Component in components:
		child.connect_signals_on_parent()
	for child: Component in components:
		child.component_init()
func _on_shoot() -> void:
	shoot_sound.play()

func _physics_process(delta: float) -> void:
	process_movement(delta)
			   
#region Movement

func process_movement(_delta: float) -> void:
	var input = movement.value_axis_2d.normalized()
	var movement_z = yaw_pivot.basis.z * -input.y
	var movement_x = yaw_pivot.basis.x * input.x
	var movement_vec = (movement_z + movement_x) * speed

	#var is_moving = movement_vec.length() > 0.1
	#if is_moving and not was_moving:
	if movement_vec.length() > 0.1 and is_on_floor():
		if foot_step_timer.is_stopped():
			footsteps.play()
			foot_step_timer.start()

	velocity = movement_vec
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
