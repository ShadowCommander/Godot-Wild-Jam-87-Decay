extends Node3D

@onready var ambience: FmodEventEmitter3D = $Ambience


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
   ambience.play()
