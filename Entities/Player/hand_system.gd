class_name HandSystem extends Component

class HandCanPickupEvent:
	var can_pickup = true

class HandPickupEvent:
	var item: Node3D = null

class HandCanDropIntoEvent:
	var can_drop = true
	var item: Node3D = null

class HandDropIntoEvent:
	var item: Node3D = null

var hand: Node3D = null

func setup_signals_on_parent() -> void:
	entity.add_user_signal("hand_can_pickup", [
		{"name": "event", "type": TYPE_OBJECT},
	])
	entity.add_user_signal("hand_pickup", [
		{"name": "event", "type": TYPE_OBJECT},
	])
	entity.add_user_signal("hand_can_drop_into", [
		{"name": "event", "type": TYPE_OBJECT},
	])
	entity.add_user_signal("hand_drop_into", [
		{"name": "event", "type": TYPE_OBJECT},
	])

func connect_signals_on_parent() -> void:
	entity.connect("hand_can_pickup", handle_can_pickup)
	entity.connect("hand_pickup", handle_pickup)
	entity.connect("hand_can_drop_into", handle_can_drop_into)
	entity.connect("hand_drop_into", handle_drop_into)

func handle_can_pickup(event: HandCanPickupEvent) -> void:
	if hand != null:
		event.can_pickup = false

func handle_pickup(event: HandPickupEvent) -> void:
	if event.item == null:
		return
	hand = event.item
	print("Picked up ", event.item, event.item.name)

func handle_can_drop_into(event: HandCanDropIntoEvent) -> void:
	if hand == null:
		event.can_drop = false
		return
	event.item = hand

func handle_drop_into(event: HandDropIntoEvent) -> void:
	event.item = hand
	hand = null
	print("Dropped ", event.item, event.item.name)
