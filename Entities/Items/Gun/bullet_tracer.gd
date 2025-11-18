class_name BulletTracer extends Node3D

const MAX_LIFETIME_MS = 5000

@export var target_pos: Vector3
@export var direction: Vector3
@export var speed: float = 300.0

@onready var death_time = Time.get_ticks_msec() + MAX_LIFETIME_MS

var speed_sq = speed * speed

func _process(delta: float) -> void:
	var diff = target_pos - global_position
	var add = diff.normalized() * speed * delta
	#if global_position.distance_squared_to(target_pos) < speed_sq * delta:
	var distance = global_position.distance_squared_to(target_pos)
	var speed_delta_sq = (speed * delta) * (speed * delta)
	if distance < speed_delta_sq:
		queue_free()
	global_position += add
	if Time.get_ticks_msec() > death_time:
		queue_free()
