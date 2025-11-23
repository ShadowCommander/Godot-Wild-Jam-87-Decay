class_name TurretAmmoLoader extends StaticBody3D

@export var ammo_max: int = 800
@export var ammo: int = 500

func _ready() -> void:
	ammo_changed()

## Adds amount to ammo. Returns the remainder.
func add_ammo(amount: int) -> int:
	var total = ammo + amount
	
	if total > ammo_max:
		ammo = ammo_max
		ammo_changed()
		if GlobalVars.debug:
			print("Ammo total: %d" % ammo)
		return total - ammo_max
	else:
		ammo = total
		ammo_changed()
		if GlobalVars.debug:
			print("Ammo total: %d" % ammo)
		return 0

func remove_ammo(amount: int) -> bool:
	if ammo > amount:
		ammo -= amount
		ammo_changed()
		#print("Ammo count: ", ammo)
		return true
	return false

@export var ammo_count_label: Label

func ammo_changed() -> void:
	ammo_count_label.text = "%d/%d" % [ammo, ammo_max]
