class_name DispenserComponent extends Component

@export var dispensed_scene: PackedScene

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
	pickup_event.item = dispensed_scene.instantiate()	
	user.emit_signal("hand_pickup", pickup_event)
