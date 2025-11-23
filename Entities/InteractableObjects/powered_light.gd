class_name PoweredLight extends Node3D

@export var power_generator: PowerGenerator
@export var light_mesh: MeshInstance3D
@export var light: Light3D

var saved_light_energy: float

func _ready() -> void:
	assert(power_generator != null, "ERROR: power_generator must be set. %s" % get_path())
	power_generator.generator_turned_off.connect(handle_generator_turned_off)
	power_generator.generator_turned_on.connect(random_delay.bind(handle_generator_turned_on))

func random_delay(call: Callable) -> void:
	await get_tree().create_timer(randf_range(0, 0.4)).timeout
	call.call()

func handle_generator_turned_off() -> void:
	saved_light_energy = light.light_energy
	light.light_energy = 0.01
	#light.hide()
	var mat = light_mesh.get_active_material(0) as StandardMaterial3D
	if mat:
		mat.emission_enabled = false
	
func handle_generator_turned_on() -> void:
	light.light_energy = saved_light_energy
	#light.show()
	var mat = light_mesh.get_active_material(0) as StandardMaterial3D
	if mat:
		mat.emission_enabled = true
