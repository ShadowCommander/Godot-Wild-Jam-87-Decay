extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_player2: AnimationPlayer = $generator_model_single_object/AnimationPlayer


func _on_power_generator_generator_turned_on() -> void:
	animation_player.play("generator on", -1, 0.5)
	#animation_player2.play("generator on")

func _on_power_generator_generator_turned_off() -> void:
	animation_player.play("generator off")
	#animation_player2.play("generator off")
