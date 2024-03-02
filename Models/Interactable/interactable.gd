extends Node2D
class_name Interactable

@onready var hitbox: Area2D = $Hitbox;
@export var startSuccess: int = 0;
@export var lengthSuccess: int = 10;
@onready var sprite: Sprite2D = $Sprite
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
const direction : Array[int] = [-1, 1];
const scales : Array[float] = [0.25, 0.5, 2, 3];

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
	deactivateAllAreas();
	if parent != null:
		self.reparent(from);
	parent = from;
	var newPos = Vector2(Global.RNG.randi_range(from.global_position.x - 20, from.global_position.x + 5),\
						(Global.RNG.randi_range(from.global_position.y - 10, from.global_position.y + 30)));
	global_position = newPos;
	tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR);
	if self is Building:
		tween.tween_property(sprite, "scale", Vector2(0.25, 0.25), 0.25).set_trans(Tween.TRANS_LINEAR).from_current();
	playCaptSound();

func deactivateCaptureArea() -> void:
	hitbox.collision_layer = 2;

func deactivateAllAreas() -> void:
	hitbox.free();
	
func failedCaptureAnimation() -> void:
	var failedDuration = Global.RNG.randf_range(0.1, 1);
	var scaleValue = scales.pick_random();
	tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR);
	tween.tween_property(self, "global_position", Vector2(Global.RNG.randi_range(-200, 600), -200), failedDuration).set_trans(Tween.TRANS_LINEAR).from_current();
	tween.parallel().tween_property(sprite, "rotation", direction.pick_random() * 3000, failedDuration).set_trans(Tween.TRANS_LINEAR).from_current();
	tween.parallel().tween_property(sprite, "scale", Vector2(scaleValue, scaleValue), failedDuration).set_trans(Tween.TRANS_LINEAR).from_current();
	playDeathSound();
	await get_tree().create_timer(1).timeout;
	free();
	
func playDeathSound() -> void:
	if self is Building:
		audio_stream_player_2d.stream = Global.BUILDING_DEATH_SOUNDS[Global.RNG.randi_range(1, 3)];
	else:
		audio_stream_player_2d.stream = Global.HUMAN_DEATH_SOUNDS[Global.RNG.randi_range(1, 3)];
	audio_stream_player_2d.pitch_scale = Global.RNG.randf_range(0.8, 1.3);
	audio_stream_player_2d.play();

func playCaptSound() -> void:
	if self is Building:
		audio_stream_player_2d.stream = Global.BUILDING_CAPT_SOUNDS[Global.RNG.randi_range(1, 3)];
		audio_stream_player_2d.pitch_scale = Global.RNG.randf_range(0.8, 0.9);
	else:
		audio_stream_player_2d.stream = Global.HUMAN_CAPT_SOUNDS[Global.RNG.randi_range(1, 3)];
		audio_stream_player_2d.pitch_scale = Global.RNG.randf_range(0.8, 1.3);
	audio_stream_player_2d.play();
