extends MeshInstance3D

@onready var electric_hum: FmodEventEmitter3D = $ElectricHum

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	electric_hum.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
