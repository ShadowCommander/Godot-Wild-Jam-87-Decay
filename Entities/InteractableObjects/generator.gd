class_name PowerGenerator extends StaticBody3D

@onready var timer: Timer = $Timer
@onready var interactable_area: InteractableArea = $InteractableArea

signal turn_off_lights
signal turn_on_lights

@export var min_time: float = 30
@export var max_time: float = 60

func _ready() -> void:
	set_random_wait_time()
	
	interactable_area.connect("pressed", handle_pressed)

func set_random_wait_time() -> void:
	timer.start(randf_range(min_time, max_time))

func _on_timer_timeout() -> void:
	turn_off_lights.emit()
	
func handle_pressed(_event: InteractionSystem.InteractionData) -> void:
	turn_on_lights.emit()
	set_random_wait_time()
