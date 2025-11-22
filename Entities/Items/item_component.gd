class_name ItemComponent extends Component

@export var item_node: Node3D

var old_process_mode: ProcessMode

func _ready() -> void:
	assert(item_node != null, "ERROR: item_node must be set. %s" % get_path())

func setup_signals_on_parent() -> void:
	entity.add_user_signal("dropped")

func connect_signals_on_parent() -> void:
	entity.connect("pressed", handle_pressed)
	entity.connect("dropped", handle_dropped)

func handle_pressed(_event: InteractionSystem.InteractionData) -> void:
	var can_pickup_event: HandSystem.HandCanPickupEvent = HandSystem.HandCanPickupEvent.new()
	var user: Node = _event.user
	if not user.has_user_signal("hand_can_pickup"):
		return
	user.emit_signal("hand_can_pickup", can_pickup_event)
	if not can_pickup_event.can_pickup:
		return
	var pickup_event: HandSystem.HandPickupEvent = HandSystem.HandPickupEvent.new()
	pickup_event.item = item_node
	user.emit_signal("hand_pickup", pickup_event)
	
	if item_node is RigidBody3D:
		old_process_mode = item_node.process_mode
		item_node.process_mode = Node.PROCESS_MODE_DISABLED

func handle_dropped() -> void:
	item_node.process_mode = old_process_mode
