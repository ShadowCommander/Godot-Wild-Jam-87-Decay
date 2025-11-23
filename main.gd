extends Node


@onready var playing_camera: Camera3D = get_viewport().get_camera_3d()	

@onready var cameras: Array[Camera3D] = [$Camera3D, playing_camera]

@onready var current_index: int = 0


func _ready() -> void:
	$Menu.Play.connect("pressed", toggle_menu)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_menu"):
		toggle_menu()

func toggle_menu():
	var inherit_mode: bool = process_mode == Node.PROCESS_MODE_INHERIT
	$Menu.visible = inherit_mode
	
	process_mode = Node.PROCESS_MODE_DISABLED if inherit_mode else Node.PROCESS_MODE_INHERIT
	print("process_mode = ", process_mode)
	if inherit_mode:
		$Camera3D.current = true
		print("$Camera3D.current = true")
	else:
		print("playing_camera.current = true")
		playing_camera.current = true

func update_camera():
	for i in range(cameras.size()):
		cameras[i].current = (i == current_index)
