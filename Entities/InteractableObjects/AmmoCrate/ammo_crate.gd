extends StaticBody3D

@onready var interactable_area: InteractableArea = $InteractableArea

@export var ammo_crate_animation_player: AnimationPlayer
@export var ammo_crate_flap: Node3D


func _ready() -> void:
	interactable_area.connect("pressed", handle_pressed)

func handle_pressed(_event: InteractionSystem.InteractionData) -> void:
	
	var tween = create_tween()
	tween.tween_property(ammo_crate_flap, "rotation:x", PI/1.5,1.5).\
	set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	
	tween.tween_property(ammo_crate_flap, "rotation:x", 0.0, 1.0).\
	set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	
