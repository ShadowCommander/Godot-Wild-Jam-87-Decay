extends Node

@onready var win_lose_manager: Node = $"../WinLoseManager"

func _on_wave_system_game_win() -> void:
	win_lose_manager.game_won()

func _on_wall_dead_wall() -> void:
	win_lose_manager.game_lost()
