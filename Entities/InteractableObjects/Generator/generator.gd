class_name PowerGenerator extends StaticBody3D

const GENERATOR_ON_MESH = preload("uid://cw28hfg52b3jh")
const GENERATOR_OFF_MESH = preload("uid://djt3vs0rk2c4j")

@onready var timer: Timer = $Timer
@onready var interactable_area: InteractableArea = $InteractableArea

signal generator_turned_off
signal generator_turned_on

@export var min_time: float = 30
@export var max_time: float = 60
@export var light_mesh: MeshInstance3D
@export var light: Light3D

func _ready() -> void:
	turn_generator_on()
	
	interactable_area.connect("pressed", handle_pressed)

func set_random_wait_time() -> void:
	timer.start(randf_range(min_time, max_time))

func _on_timer_timeout() -> void:
	turn_generator_off()
	
func handle_pressed(_event: InteractionSystem.InteractionData) -> void:
	turn_generator_on()

func turn_generator_off() -> void:
	generator_turned_off.emit()
	light_mesh.mesh = GENERATOR_OFF_MESH
	light.show()

func turn_generator_on() -> void:
	generator_turned_on.emit()
	set_random_wait_time()
	light_mesh.mesh = GENERATOR_ON_MESH
	light.hide()
