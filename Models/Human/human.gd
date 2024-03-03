extends Interactable
class_name Human

func _ready() -> void:
	scoreValue = 10;
	startSuccess = 30;
	lengthSuccess = 30;
	animation_player.play("default")
