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
	var target: Node3D = null

@export var hand_position: Node3D

var hand: Node3D = null

func _process(delta: float) -> void:
	process_animation(delta)

#region Component signals

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

#endregion

#region Pickup

func handle_can_pickup(event: HandCanPickupEvent) -> void:
	if hand != null:
		event.can_pickup = false

func handle_pickup(event: HandPickupEvent) -> void:
	if event.item == null:
		return
	
	var item = event.item
	hand = item
	animate_item_movement(item, hand_position)
	print("Picked up ", event.item, event.item.name)

#endregion

#region Drop

func handle_can_drop_into(event: HandCanDropIntoEvent) -> void:
	if hand == null:
		event.can_drop = false
		return
	event.item = hand

func handle_drop_into(event: HandDropIntoEvent) -> void:
	event.item = hand
	animate_item_movement(hand, event.target, handle_item_dropped.bind(hand))
	hand = null
	event.item.emit_signal("dropped")
	print("Dropped ", event.item, event.item.name)

#endregion

#region Animation

var item_pickup_time: float = 0.2
var current_time: float = 0
var start: Vector3
var end_node: Node3D
var animating_item: Node3D

var pickup: bool = false
var call: Callable

func process_animation(delta: float) -> void:
	if not pickup:
		return
	current_time += delta
	var weight: float = min(current_time / item_pickup_time, 1.0)
	animating_item.global_position = lerp(start, end_node.global_position, ease(weight, 3))
	if weight >= 1:
		pickup = false
		call.call()
		current_time = 0

func animate_item_movement(item: Node3D, target: Node3D, callback: Callable = handle_item_picked_up.bind(item)) -> void:
	start = item.global_position
	end_node = target
	pickup = true
	call = callback
	animating_item = item
	
@onready var root = get_tree().root

func handle_item_picked_up(item: Node3D) -> void:
	item.reparent(hand_position, false)
	item.position = Vector3.ZERO

func handle_item_dropped(item: Node3D) -> void:
	item.reparent(root, true)

#endregion
