class_name PoweredLight extends StaticBody3D

@export var power_generator: PowerGenerator
@export var light_mesh: MeshInstance3D
@export var light: Light3D

func _ready() -> void:
	power_generator.turn_off_lights.connect(handle_turn_off_lights)
	power_generator.turn_on_lights.connect(handle_turn_on_lights)

func handle_turn_off_lights() -> void:
	light.hide()
	var mat = light_mesh.mesh.material as StandardMaterial3D
	if mat:
		mat.emission_enabled = false
	
func handle_turn_on_lights() -> void:
	light.show()
	var mat = light_mesh.mesh.material as StandardMaterial3D
	if mat:
		mat.emission_enabled = true
