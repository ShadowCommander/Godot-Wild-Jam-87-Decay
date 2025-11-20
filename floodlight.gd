class_name Floodlight extends PoweredLight 




func handle_generator_turned_off() -> void:
	
	light.hide()
	light_mesh.hide()
	pass


func handle_generator_turned_on() -> void:
	light.show()
	light_mesh.show()
	pass
