extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_power_generator_generator_turned_on() -> void:
	animation_player.play("generator on", -1, 0.5)

func _on_power_generator_generator_turned_off() -> void:
	animation_player.play("generator off")
