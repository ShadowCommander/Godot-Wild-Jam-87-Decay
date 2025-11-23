extends Node


@onready var Play: Button = $VBoxContainer/Play

	#get_tree().change_scene_to_file("res://main.tscn")


func _on_options_pressed() -> void:
	print("options pressed")


func _on_achievements_pressed() -> void:
	print("achievements pressed")


func _on_exit_pressed() -> void:
	get_tree().quit()
