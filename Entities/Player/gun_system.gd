extends Node

const BULLET_TRACER = preload("uid://bwwahw1qukqlr")

const BULLET_COLLISION_MASK = 0b100
const RAY_LENGTH = 1000

@export var shoot: GUIDEAction
@export var camera: Camera3D
@export var player_body: CharacterBody3D
@export var origin_node: Node3D
@export var shot_visuals_mesh: MeshInstance3D

# Since mouse input detection of 3D objects is currently broken when mouse mode is captured, we need to raycast manually to detect things clicked on.
# https://github.com/godotengine/godot/issues/29727

var space_state: PhysicsDirectSpaceState3D
var viewport: Viewport
var query: PhysicsRayQueryParameters3D

#region Setup

func _ready() -> void:
	shoot.triggered.connect(handle_shoot)
	shoot.completed.connect(handle_shoot_completed)
	space_state = camera.get_world_3d().direct_space_state
	viewport = get_viewport()
	query = PhysicsRayQueryParameters3D.create(Vector3.ZERO, Vector3.ZERO, BULLET_COLLISION_MASK)

#endregion

#region Utilities

func raycast(max_iterations: int = 1) -> Array[Dictionary]:
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

	return multi_raycast(space_state, query, max_iterations)

## Executes intersect_ray query repeatedly, penetrating through different objects until there are no hits left
## Returns an array of result dictionaries (see PhysicsDirectSpaceState3D.intersect_ray docs)
## https://github.com/godotengine/godot-proposals/discussions/6377#discussioncomment-12965646
static func multi_raycast(_space_state: PhysicsDirectSpaceState3D, _query: PhysicsRayQueryParameters3D, max_iterations: int = 100) -> Array[Dictionary]:
	var next_query = _query
	var hits: Array[Dictionary] = []
	var exclusions: Array[RID] = _query.exclude
	var counter := 0
	
	while (next_query != null) and (not counter > max_iterations):
		var result = _space_state.intersect_ray(next_query)
		if !result.is_empty():
			hits.append(result.duplicate())
			exclusions.append(result.rid)
		next_query = null if result.is_empty() else PhysicsRayQueryParameters3D.create(_query.from, _query.to, _query.collision_mask, exclusions)
		counter += 1
	
	return hits

#endregion

#region Shoot

var damage: int = 10000
var pierce_count: int = 1

var rounds_per_minute: float = 600
var milliseconds_per_round: int = int(60000 / rounds_per_minute)
var shots_fired: int = 0
var next_fire_time: int = 0
var held: bool = false
# When new firing set new next_fire_time to `Time.get_ticks_msec() + milliseconds_per_round`
# When continuous fire set next_fire_time to `next_fire_time + milliseconds_per_round`
var tracer_rate: int = 1
var bullets_fired: int = 0

func handle_shoot() -> void:
	if Time.get_ticks_msec() < next_fire_time:
		return
	if held:
		next_fire_time += milliseconds_per_round
	else:
		next_fire_time = Time.get_ticks_msec() + milliseconds_per_round
	held = true
	
	var results = raycast(pierce_count)
	var end_position: Vector3 = query.to
	for result in results:
		var collided: Area3D = result.get("collider")
		if collided.has_method("receive_damage"):
			collided.receive_damage(Hurtbox.DamageData.new(damage))
		end_position = result.position
	
	if bullets_fired % tracer_rate == 0:
		show_shoot_visuals(end_position)
	bullets_fired += 1

var min_distance_sq = 3 * 3

func handle_shoot_completed() -> void:
	held = false

func show_shoot_visuals(target_point: Vector3) -> void:
	if origin_node.global_position.distance_squared_to(target_point) < min_distance_sq:
		return
	shots_fired += 1
	var tracer: BulletTracer = BULLET_TRACER.instantiate()
	tracer.target_pos = target_point
	tracer.look_at_from_position(origin_node.global_position, target_point)
	get_tree().root.add_child(tracer)

#endregion
