class_name Wall extends Node3D
signal dead_wall

const WALL_PANEL = preload("uid://tm0qf2uc663m")

@export var health_component: HealthComponent
@export var wall_panel_spawn_area_marker_1: Marker3D
@export var wall_panel_spawn_area_marker_2: Marker3D
@export var wall_panel_container: Node3D

var old_health_percent: int = 1.0
var thresholds: Array[float] = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9]
var threshold_index: int = thresholds.size() - 1

func _ready() -> void:
	assert(health_component != null, "ERROR: health_component must be set. %s" % get_path())
	assert(wall_panel_spawn_area_marker_1 != null, "ERROR: wall_panel_spawn_area_marker_1 must be set. %s" % get_path())
	assert(wall_panel_spawn_area_marker_2 != null, "ERROR: wall_panel_spawn_area_marker_2 must be set. %s" % get_path())
	assert(wall_panel_container != null, "ERROR: wall_panel_container must be set. %s" % get_path())
	if health_component:
		health_component.MAX_HEALTH = GlobalVars.wall_health
		health_component.health = GlobalVars.wall_health
		health_component.health_changed.connect(_on_health_changed)

func get_health_component():
	return health_component

func _on_health_changed(health: int):
	if GlobalVars.debug:
		print("%s damaged. Health: %d" % [name, health])
	
	var health_percent: float = health / health_component.MAX_HEALTH
	if threshold_index > 0 and health_percent < thresholds[threshold_index]:
		threshold_index -= 1
		spawn_panel()
	old_health_percent = health_percent
	if health <= 0:
		dead_wall.emit()
		hide()
		
	pass

func spawn_panel() -> void:
	var panel: RigidBody3D = WALL_PANEL.instantiate()
	var pos1 = wall_panel_spawn_area_marker_1.global_position
	var pos2 = wall_panel_spawn_area_marker_2.global_position
	var size = pos2 - pos1
	var rand_pos = Vector3(randf_range(0, size.x), randf_range(0, size.y), randf_range(0, size.z))
	
	var spawn_position = pos1 + rand_pos
	var imp = basis * Vector3(randf_range(-1, -6), randf_range(0, 4), randf_range(-2, 2))
	wall_panel_container.add_child(panel)
	panel.global_position = spawn_position
	panel.apply_impulse(imp)
	panel.apply_torque(Vector3(randf_range(-180, 180), randf_range(0, 180), randf_range(0, 180)))
	
