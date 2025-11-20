extends Node3D

const BULLET_COLLISION_MASK = 0b100
const RAY_LENGTH = 1000


const BULLET_TRACER = preload("uid://bwwahw1qukqlr")
const HITSCAN_TRACER = preload("uid://cbt8wa4rdgia4")

@export var pivot: Node3D
@export var muzzle: Node3D
@export var player_body: CharacterBody3D

var targets: Dictionary = {}

var space_state: PhysicsDirectSpaceState3D
var viewport: Viewport
var query: PhysicsRayQueryParameters3D

func _ready() -> void:
	assert(ammo_loader != null, "ERROR: ammo_loader must be set. %s" % get_path())
	
	space_state = get_world_3d().direct_space_state
	viewport = get_viewport()
	query = PhysicsRayQueryParameters3D.create(Vector3.ZERO, Vector3.ZERO, BULLET_COLLISION_MASK)

func _on_enemy_detection_area_area_shape_entered(area_rid: RID, area: Area3D, _area_shape_index: int, _local_shape_index: int) -> void:
	targets[area_rid] = area

func _on_enemy_detection_area_area_shape_exited(area_rid: RID, area: Area3D, _area_shape_index: int, _local_shape_index: int) -> void:
	targets.erase(area_rid)
	if target_rid == area_rid:
		handle_shoot_completed()

# Fire at target until dead
# Turn to enemy that takes the least amount of rotation.

# Preditive targeting
var old_target_pos: Vector3
var target_rid: RID = RID()
var target: Node3D = null

func _physics_process(delta: float) -> void:
	turret_process()

func turret_process() -> void:
	if targets.size() <= 0:
		return
	if target == null:
		for rid in targets:
			target = targets[rid]
			target_rid = rid
			break
	
	# Disable when target dies
	
	if not target.visible or global_position.distance_squared_to(target.global_position) > 160000:
		return
	
	aim_at_target(target)
	if global_position.angle_to(target.global_position) > 0.01:
		handle_shoot((target.global_position - muzzle.global_position).normalized() * RAY_LENGTH)
	else:
		handle_shoot_completed()

func aim_at_target(target: Node3D) -> void:
	pivot.look_at(target.global_position)

#region Utilities

func raycast(target_vector: Vector3, max_iterations: int = 1) -> Array[Dictionary]:
	#var new_pos = cursor.value_axis_3d
	var mousepos = get_viewport().get_visible_rect().size / 2
	var origin = muzzle.global_position
	var end = origin + target_vector
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

@export var damage: int = 2000
@export var pierce_count: int = 1

@export var rounds_per_minute: float = 600:
	set(value):
		milliseconds_per_round = int(60000 / value)
		rounds_per_minute = value
var milliseconds_per_round: int = int(60000 / rounds_per_minute)
var shots_fired: int = 0
var next_fire_time: int = 0
var held: bool = false
# When new firing set new next_fire_time to `Time.get_ticks_msec() + milliseconds_per_round`
# When continuous fire set next_fire_time to `next_fire_time + milliseconds_per_round`
var tracer_rate: int = 1
var bullets_fired: int = 0

@export var visual_accuracy_drift = 0.2

func handle_shoot(target_vector: Vector3) -> void:
	if Time.get_ticks_msec() < next_fire_time:
		return
	if held:
		next_fire_time += milliseconds_per_round
	else:
		next_fire_time = Time.get_ticks_msec() + milliseconds_per_round
	print("msec: %d, next_fire_time: %d, ms_per_round: %d, held: %s" % [Time.get_ticks_msec(), next_fire_time, milliseconds_per_round, held])
	held = true
	
	if not can_fire():
		return
	
	var results = raycast(target_vector, pierce_count)
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
	target = null

func show_shoot_visuals(target_point: Vector3) -> void:
	if muzzle.global_position.distance_squared_to(target_point) < min_distance_sq:
		return
	shots_fired += 1
	
	target_point += Vector3(randf_range(-visual_accuracy_drift, visual_accuracy_drift), randf_range(-visual_accuracy_drift, visual_accuracy_drift), randf_range(-visual_accuracy_drift, visual_accuracy_drift))
	
	#var tracer: BulletTracer = BULLET_TRACER.instantiate()
	#tracer.target_pos = target_point
	#tracer.look_at_from_position(muzzle.global_position, target_point)
	var tracer: HitscanTracer = HITSCAN_TRACER.instantiate()
	tracer.init(muzzle.global_position, target_point)
	get_tree().root.add_child(tracer)

#endregion

#region Ammo

@export var ammo_loader: TurretAmmoLoader

func can_fire() -> bool:
	if not ammo_loader.remove_ammo(1):
		return false
	return true

#endregion
