extends Node

@export var player_movement_keyboard_context: GUIDEMappingContext
@export var keyboard_menu: GUIDEMappingContext

@export var toggle_cursor: GUIDEAction

func _ready() -> void:
	GUIDE.enable_mapping_context(player_movement_keyboard_context, true)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	toggle_cursor.triggered.connect(on_toggle_cursor)

func on_toggle_cursor() -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		GUIDE.enable_mapping_context(player_movement_keyboard_context, true)
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		GUIDE.enable_mapping_context(keyboard_menu, true)
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
