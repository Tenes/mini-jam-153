extends Node2D
class_name Interactable

var scoreValue: int = 0;
var parent: Node2D;
@export var startSuccess: int = 0;
@export var lengthSuccess: int = 10;

func _process(delta: float) -> void:
	global_position.x += (1 * delta * 100);

func spawnFrom(from: Node2D):
	parent = from;
	parent.add_child(self);
	global_position = Vector2(-30, 260)

func isSuccessfullyChallenged(successState: Global.BarStatus):
	if successState == Global.BarStatus.SUCCESS:
		print("SUCCESS");
	elif successState == Global.BarStatus.GREAT_SUCCESS:
		print("GREAT SUCCESS");
	else:
		pass;

func _on_hitbox_area_entered(area):
	Events.on_interactable_collided.emit(startSuccess, lengthSuccess);
	Events.bar_clicked.connect(isSuccessfullyChallenged);
