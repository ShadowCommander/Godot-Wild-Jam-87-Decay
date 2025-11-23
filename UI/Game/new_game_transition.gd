extends TextureRect

var transition_time: float = 2

func _process(delta: float) -> void:
	
	create_tween().bind_node(self).tween_property(self, "modulate", Color.TRANSPARENT, transition_time)
