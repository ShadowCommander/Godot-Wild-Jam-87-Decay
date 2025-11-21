class_name Wall extends Node3D
signal dead_wall

@export var health_component: HealthComponent

func _ready() -> void:
	if health_component:
		health_component.health_changed.connect(_on_health_changed)

func get_health_component():
	return health_component

func _on_health_changed(health: int):
	if GlobalVars.debug:
		print("%s damaged. Health: %d" % [name, health])
	if health <= 0:
		dead_wall.emit()
		hide()
		
	pass
