class_name DispenserComponent extends Component

@export var dispensed_scene: PackedScene
@export var spawn_position: Node3D

func connect_signals_on_parent() -> void:
	entity.connect("pressed", handle_pressed)

func handle_pressed(_event: InteractionSystem.InteractionData) -> void:
	var can_pickup_event: HandSystem.HandCanPickupEvent = HandSystem.HandCanPickupEvent.new()
	var user: Node = _event.user
	if not user.has_user_signal("hand_can_pickup"):
		return
	user.emit_signal("hand_can_pickup", can_pickup_event)
	if not can_pickup_event.can_pickup:
		return
	var pickup_event: HandSystem.HandPickupEvent = HandSystem.HandPickupEvent.new()
	var item: Node3D = dispensed_scene.instantiate()
	get_tree().root.add_child(item)
	item.global_position = spawn_position.global_position
	item.reset_physics_interpolation()
	pickup_event.item = item
	user.emit_signal("hand_pickup", pickup_event)
