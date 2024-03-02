extends Node2D
class_name Interactable

@onready var hitbox: Area2D = $Hitbox;
@export var startSuccess: int = 0;
@export var lengthSuccess: int = 10;
var moovement: int = 1;
var tween: Tween;
var scoreValue: int = 0;
var parent: Node2D;

func _process(delta: float) -> void:
	global_position.x += (moovement * delta * 100);

func spawnFrom(from: Node2D) -> void:
	parent = from;
	parent.add_child(self);
	global_position = from.global_position

func bindTo(from: Node2D) -> void:
	moovement = 0;
	if parent != null:
		call_deferred("reparent", from);
	else:
		from.add_child(self);
	parent = from;
	global_position = Vector2(from.global_position.x - 5, from.global_position.y);

func deactivateCaptureArea() -> void:
	hitbox.collision_layer = 2;
