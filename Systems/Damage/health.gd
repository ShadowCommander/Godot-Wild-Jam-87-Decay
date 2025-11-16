class_name HealthComponent extends Node

# Health will be a fixed decimal 2 integer 100.00
var health: int = 10000

func take_damage(damage: int) -> void:
	health -= damage
