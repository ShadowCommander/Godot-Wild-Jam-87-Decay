class_name DimmingLight extends PoweredLight

@export var light_max_energy: float = 1

func handle_generator_turned_off() -> void:
    var t = light.create_tween()
    #fades light energy to 0.0 over 10.0 seconds
    t.tween_property($OmniLight3D, "light_energy", 0.0, 0.3)
    t.set_ease(Tween.EASE_OUT)
    t.set_trans(Tween.TRANS_CIRC)
    if light_mesh != null:
        var mat = light_mesh.mesh.material as StandardMaterial3D
        if mat:
            mat.emission_enabled = false
    
func handle_generator_turned_on() -> void:
    light.light_energy = light_max_energy
    light.show()
    if light_mesh != null:
        var mat = light_mesh.mesh.material as StandardMaterial3D
        if mat:
            mat.emission_enabled = true
