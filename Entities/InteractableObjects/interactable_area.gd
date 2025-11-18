extends Area3D
class_name InteractableArea

@export var mesh: MeshInstance3D

const OUTLINE_SHADER_MATERIAL = preload("uid://dep3tllk45lhr")

# CanInteract
# StartInteract
# EndInteract
# For pressed, check if interaction system target is still this node. If not then do not interact
# Focused
# Unfocused
# Pressed

func _ready() -> void:
	collision_layer = InteractionSystem.RAYCAST_COLLISION_MASK
	collision_mask = InteractionSystem.RAYCAST_COLLISION_MASK
	setup_signals_on_parent()
	connect_signals_on_parent()

	var children = get_children()
	var components = children.filter(func(child): return child is Component)
	for child: Component in components:
		child.entity = self
		child.setup_signals_on_parent()
	for child: Component in components:
		child.connect_signals_on_parent()
	for child: Component in components:
		child.component_init()

#region Setup

func setup_signals_on_parent() -> void:
	add_user_signal("can_interact", [
		{"name": "data", "type": TYPE_OBJECT},
	])

	add_user_signal("start_interact", [
		{"name": "data", "type": TYPE_OBJECT},
	])
	add_user_signal("end_interact")
	add_user_signal("pressed")

	add_user_signal("focused")
	add_user_signal("unfocused")
	print(has_user_signal("focused"))

func connect_signals_on_parent() -> void:
	connect("can_interact", handle_can_interact)

	connect("start_interact", handle_start_interact)
	connect("end_interact", handle_end_interact)
	connect("pressed", handle_pressed)
#
	connect("focused", handle_focused)
	connect("unfocused", handle_unfocused)

#endregion

#region Can Override

func handle_can_interact(_event: InteractionSystem.InteractionAttemptEvent) -> void:
	print("Can interact: ", self)
	pass

func handle_start_interact(_event: InteractionSystem.InteractionData) -> void:
	print("Start interact: ", self)
	pass

func handle_end_interact(_event: InteractionSystem.InteractionData) -> void:
	print("End interact: ", self)
	pass

func handle_pressed(_event: InteractionSystem.InteractionData) -> void:
	print("Pressed interact: ", self)
	pass

func handle_focused() -> void:
	mesh.material_overlay = OUTLINE_SHADER_MATERIAL
	pass

func handle_unfocused() -> void:
	mesh.material_overlay = null
	pass

#endregion
