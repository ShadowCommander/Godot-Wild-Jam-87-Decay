class_name TurretAmmoLoader extends StaticBody3D

@export var ammo_max: int = 800
@export var ammo: int = 500

## Adds amount to ammo. Returns the remainder.
func add_ammo(amount: int) -> int:
	var total = ammo + amount
	
	if total > ammo_max:
		ammo = ammo_max
		return total - ammo_max
	else:
		ammo = total
		return 0

func remove_ammo(amount: int) -> bool:
	if ammo > amount:
		ammo -= amount
		print("Ammo count: ", ammo)
		return true
	return false
