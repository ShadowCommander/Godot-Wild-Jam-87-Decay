extends Node3D

@onready var ambience: FmodEventEmitter3D = $Ambience


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
   ambience.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
