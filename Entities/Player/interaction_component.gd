extends Node
class_name InteractionSystem

const RAYCAST_COLLISION_MASK = 0b10000000

class InteractionAttemptEvent:
	var cancelled: bool = false
	
	func stop():
		cancelled = true

class InteractionData:
	var user: Node
	var disable_camera: bool
	
	func reset() -> void:
		disable_camera = false

const RAY_LENGTH = 1000

@export var interact: GUIDEAction
@export var cursor: GUIDEAction
@export var mouse_movement: GUIDEAction
@export var camera: Camera3D
@export var player_body: CharacterBody3D
@export var mouse_capture_system: Node

# Since mouse input detection of 3D objects is currently broken when mouse mode is captured, we need to raycast manually to detect things clicked on.
# https://github.com/godotengine/godot/issues/29727

var space_state: PhysicsDirectSpaceState3D
var viewport: Viewport
var query: PhysicsRayQueryParameters3D

var interacted_node: Node3D = null
var interaction_data: InteractionData = null

# Focus
var focused_node: Node3D

#region Setup

func _ready() -> void:
	interact.triggered.connect(handle_interact)
	interact.completed.connect(handle_interact_completed)
	mouse_movement.triggered.connect(handle_mouse_movement)
	space_state = camera.get_world_3d().direct_space_state
	viewport = get_viewport()
	query = PhysicsRayQueryParameters3D.create(Vector3.ZERO, Vector3.ZERO)

#endregion

#region Utilities

func raycast() -> Dictionary:
	#var new_pos = cursor.value_axis_3d
	var mousepos = get_viewport().get_visible_rect().size / 2
	var origin = camera.project_ray_origin(mousepos)
	var end = origin + camera.project_ray_normal(mousepos) * RAY_LENGTH
	#var end = origin + new_pos * RAY_LENGTH
	query.from = origin
	query.to = end
	query.collide_with_areas = true
	if player_body:
		query.exclude = [player_body]

	return space_state.intersect_ray(query)

#endregion

#region Interaction

# On null to interacted_node:
#   Emit start_interact
# On interacted_node to null
#   Emit end_interact
# If focused_node == interacted_node
#   Emit pressed
func handle_interact() -> void:
	if interacted_node == null:
		if focused_node != null and focused_node.has_user_signal("can_interact"):
			var attempt = InteractionAttemptEvent.new()
			focused_node.emit_signal("can_interact", attempt)
			if attempt.cancelled:
				return
		
		interacted_node = focused_node
		if interacted_node != null and interacted_node.has_user_signal("start_interact"):
			interaction_data = InteractionData.new()
			interaction_data.user = player_body
			interacted_node.emit_signal("start_interact", interaction_data)
			#if interaction_data.disable_camera:
				#mouse_capture_system.lock_mouse(self)

func handle_interact_completed() -> void:
	if interacted_node == null:
		return
	if interacted_node.has_signal("end_interact"):
		interacted_node.emit_signal("end_interact", interaction_data)
		#if interaction_data.disable_camera:
			#mouse_capture_system.unlock_mouse(self)
	if focused_node == interacted_node:
		if interacted_node.has_signal("pressed"):
			interacted_node.emit_signal("pressed", interaction_data)
	interacted_node = null
	interaction_data = null

func can_interact() -> bool:
	if focused_node != null and focused_node.has_user_signal("can_interact"):
		var attempt = InteractionAttemptEvent.new()
		focused_node.emit_signal("can_interact", attempt)
		if attempt.cancelled:
			return false
		return true
	return false

#endregion

#region Focus

var previous_focused_node: Node3D

func handle_mouse_movement() -> void:
	var result = raycast()
	focused_node = result.get("collider")
	
	if focused_node != previous_focused_node:
		if previous_focused_node != null and previous_focused_node.has_user_signal("unfocused"):
			previous_focused_node.emit_signal("unfocused")
		previous_focused_node = focused_node
		if focused_node != null and focused_node.has_user_signal("focused"):
			focused_node.emit_signal("focused")
		#if can_interact(focused_node):
			#focused_node.emit_signal("set_outline_color", Color.RED)

#endregion
