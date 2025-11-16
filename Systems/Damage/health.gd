class_name HealthComponent extends Node
signal health_changed
# Health will be a fixed decimal 2 integer 100.00
var MAX_HEALTH: int = 200
var health: int = MAX_HEALTH


func _ready():
	
	
	pass

func take_damage(damage: int) -> void:
	health = clamp(health - damage, 0, INF)
	health_changed.emit(health)
	

func reset():
	health = MAX_HEALTH
	pass
