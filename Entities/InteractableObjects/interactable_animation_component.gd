extends Component
class_name InteractableAnimationComponent

@export var animation_player: AnimationPlayer
@export var animation_name: String

func setup_signals_on_parent() -> void:
	entity.connect("pressed", handle_pressed)

func handle_pressed(_event: InteractionSystem.InteractionData) -> void:
	animation_player.seek(0)
	animation_player.play(animation_name)
