class_name NodePool
extends Node


@export var pooled_scene: PackedScene
@export var initial_pool_size: int = 100

var pool: Array[Node] = []
var pool_size: int = 0
var index: int = 0
var active_counter: Array[int] = [0]
var container: Node

func _ready() -> void:
	container = Node.new()
	add_child(container)
	
	increase_pool_size(initial_pool_size)


func increase_pool_size(size: int) -> void:
	pool_size += size
	for i in size:
		var node: Node = pooled_scene.instantiate()
		
		node.add_user_signal("return_to_pool", [TYPE_OBJECT])
		node.connect("return_to_pool", set_pooled_active.bind(false))
		
		pool.append(node)
		container.add_child(node)

		set_pooled_active(node, false, false)


func get_pooled() -> Node:
	var actives: Array = pool.filter(
			func(n):
				return not (n.is_processing() and n.visible))
	
	var node: Node = null
	
	if actives.is_empty():
		increase_pool_size(100)
		node = pool.back()
	else:
		node = actives.front()
	
	set_pooled_active(node, true)
	return node
	
	#if pool.is_empty():
		#increase_pool_size(1)
	#var node: Node = pool[index]
	#if node.is_processing() and node.visible:
		#index = pool_size + 1
		#increase_pool_size(100)
		#node = pool[index]
	#index = wrapi(index + 1, 0, pool_size - 1) # Pool creates nodes in a circular pool, so this works better with nodes that have a time limit.
	#set_pooled_active(node, true)

func set_pooled_active(node: Node, value: bool, increment_counter: bool = true) -> void:
	# Turning off processing and hiding the rendering is faster than queue_free.
	node.set_process(value)
	node.set_physics_process(value)
	


	
	
	if value:
		node.show()
		if increment_counter:
			active_counter[0] += 1
	else:
		node.hide()
		
		## HACK This is an easy way to not have to deal with disabling/enabling
		## elements of a pooled node that can impact things if it remains nearby
		## but hidden
		node.global_transform.origin = Vector3.DOWN * 500
		
		if increment_counter:
			active_counter[0] -= 1

func set_pooled_node(scene: PackedScene) -> void:
	pooled_scene = scene
