extends Node2D
class_name Interactable

@onready var hitbox: Area2D = $Hitbox;
@export var startSuccess: int = 0;
@export var lengthSuccess: int = 10;
@onready var sprite: Sprite2D = $Sprite
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
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
	playCaptSound();

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
	playDeathSound();
	await get_tree().create_timer(1).timeout;
	free();
	
func playDeathSound() -> void:
	if self is Building:
		audio_stream_player_2d.stream = Global.BUILDING_DEATH_SOUNDS[Global.RNG.randi_range(1, 2)];
	else:
		audio_stream_player_2d.stream = Global.HUMAN_DEATH_SOUNDS[Global.RNG.randi_range(1, 3)];
	audio_stream_player_2d.pitch_scale = Global.RNG.randf_range(0.8, 1.3);
	audio_stream_player_2d.play();

func playCaptSound() -> void:
	if self is Building:
		audio_stream_player_2d.stream = Global.BUILDING_CAPT_SOUNDS[Global.RNG.randi_range(1, 1)];
		audio_stream_player_2d.pitch_scale = Global.RNG.randf_range(0.7, 0.8);
	else:
		audio_stream_player_2d.stream = Global.HUMAN_CAPT_SOUNDS[Global.RNG.randi_range(1, 2)];
		audio_stream_player_2d.pitch_scale = Global.RNG.randf_range(0.8, 1.3);
	audio_stream_player_2d.play();
