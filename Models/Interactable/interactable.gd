extends Node2D
class_name Interactable

@onready var hitbox: Area2D = $Hitbox;
@export var startSuccess: int = 0;
@export var lengthSuccess: int = 10;
@onready var sprite: Sprite2D = $Sprite
const direction : Array[int] = [-1, 1];

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

func bindTo(from: Node2D, gap: int) -> void:
	moovement = 0;
	deactivateAllAreas();
	if parent != null:
		self.reparent(from);
	parent = from;
	global_position = Vector2(from.global_position.x - gap, from.global_position.y);

func deactivateCaptureArea() -> void:
	hitbox.collision_layer = 2;

func deactivateAllAreas() -> void:
	hitbox.free();
	
func failedCaptureAnimation() -> void:
	var failedDuration = Global.RNG.randf_range(0.01, 1);
	var scaleValue = Global.RNG.randi_range(1, 4);
	tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR);
	tween.tween_property(self, "global_position", Vector2(Global.RNG.randi_range(-200, 600), -100), failedDuration).set_trans(Tween.TRANS_LINEAR).from_current();
	tween.parallel().tween_property(sprite, "rotation", direction.pick_random() * 3000, failedDuration).set_trans(Tween.TRANS_LINEAR).from_current();
	tween.parallel().tween_property(sprite, "scale", Vector2(scaleValue, scaleValue), failedDuration).set_trans(Tween.TRANS_LINEAR).from_current();
	await get_tree().create_timer(1).timeout;
	queue_free();
