class_name PoweredLight extends StaticBody3D

@export var power_generator: PowerGenerator
@export var light_mesh: MeshInstance3D
@export var light: Light3D

func _ready() -> void:
	power_generator.generator_turned_off.connect(handle_generator_turned_off)
	power_generator.generator_turned_on.connect(handle_generator_turned_on)

func handle_generator_turned_off() -> void:
	light.hide()
	var mat = light_mesh.get_active_material(0) as StandardMaterial3D
	if mat:
		mat.emission_enabled = false
	
func handle_generator_turned_on() -> void:
	light.show()
	var mat = light_mesh.get_active_material(0) as StandardMaterial3D
	if mat:
		mat.emission_enabled = true
