class_name Hurtbox extends Area3D

@export var health_component: HealthComponent

func receive_damage(data: DamageData) -> void:
	if health_component == null:
		printerr("Hurtbox should have a HealthComponent assigned!")
		return
	if data == null:
		printerr("_receive_damage AttackComboEntry is null!")
		return
	
	health_component.take_damage(data.damage) # Hitbox → HURTBOX → Health

class DamageData:
	var damage: int = 0
	
	func _init(_damage: int) -> void:
		damage = _damage
