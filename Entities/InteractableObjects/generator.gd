class_name PowerGenerator extends StaticBody3D

@onready var timer: Timer = $Timer
@onready var interactable_area: InteractableArea = $InteractableArea

signal generator_turned_off
signal generator_turned_on

@export var min_time: float = 30
@export var max_time: float = 60

func _ready() -> void:
	set_random_wait_time()
	
	interactable_area.connect("pressed", handle_pressed)

func set_random_wait_time() -> void:
	timer.start(randf_range(min_time, max_time))

func _on_timer_timeout() -> void:
	generator_turned_off.emit()
	
func handle_pressed(_event: InteractionSystem.InteractionData) -> void:
	generator_turned_on.emit()
	set_random_wait_time()
