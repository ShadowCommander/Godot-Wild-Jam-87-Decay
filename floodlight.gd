class_name Floodlight extends PoweredLight 

func handle_generator_turned_off() -> void:
	saved_light_energy = light.light_energy
	light.light_energy = 0.01
	#light.hide()
	light_mesh.hide()

func handle_generator_turned_on() -> void:
	light.light_energy = saved_light_energy
	#light.show()
	light_mesh.show()
