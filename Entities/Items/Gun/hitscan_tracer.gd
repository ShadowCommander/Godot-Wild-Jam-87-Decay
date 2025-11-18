class_name HitscanTracer extends MeshInstance3D

const MAX_LIFETIME_MS: int = 500
var alpha_reduction_per_second: float = 1 / (MAX_LIFETIME_MS * 0.001)

var start_color = Color("ffab40")
var end_color = Color.BLACK

@export var value_curve: Curve

# 200 MS
# Fade should be 0 at 200 MS
# Fade should be 1.0 at 0 MS
# delta average = 0.16
# fade per millisecond = 1 / MAX_LIFETIME_MS
# fade per second = 1 / (MAX_LIFETIME_MS * 1000)
# fade per delta = fps * delta
@onready var death_time = Time.get_ticks_msec() + MAX_LIFETIME_MS

var progress: float = 0.0

func init(pos1: Vector3, pos2: Vector3) -> void:
	var draw_mesh = ImmediateMesh.new()
	mesh = draw_mesh
	draw_mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	draw_mesh.surface_add_vertex(pos1)
	draw_mesh.surface_add_vertex(pos2)
	draw_mesh.surface_end()

func _process(delta: float) -> void:
	progress += delta * alpha_reduction_per_second
	var value = value_curve.sample(progress)
	var mat = material_override as StandardMaterial3D
	var color = end_color.lerp(start_color, value)
	color.a = value
	mat.albedo_color = color
	mat.albedo_color.a = value
	mat.emission = color
	mat.emission_energy_multiplier = 4 * value

func _physics_process(_delta: float) -> void:
	if Time.get_ticks_msec() > death_time:
		queue_free()
