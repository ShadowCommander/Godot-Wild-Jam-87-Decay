class_name AmmoItemReceiverComponent extends Component

@export var turret_ammo_loader: TurretAmmoLoader

func connect_signals_on_parent() -> void:
	entity.connect("pressed", handle_pressed)

func handle_pressed(_event: InteractionSystem.InteractionData) -> void:
	var user: Node = _event.user

	var can_drop_into_event: HandSystem.HandCanDropIntoEvent = HandSystem.HandCanDropIntoEvent.new()

	if not user.has_user_signal("hand_can_drop_into"):
		return
	user.emit_signal("hand_can_drop_into", can_drop_into_event)
	if not can_drop_into_event.can_drop:
		return
	var item = can_drop_into_event.item 
	if item is not AmmoBox:
		return

	var drop_into_event: HandSystem.HandDropIntoEvent = HandSystem.HandDropIntoEvent.new()
	drop_into_event.target = entity
	user.emit_signal("hand_drop_into", drop_into_event)
	
	user.emit_signal("change_ammo", item.ammo_count)
	print("Inserting ammo %d" % item.ammo_count)
	turret_ammo_loader.add_ammo(item.ammo_count)
