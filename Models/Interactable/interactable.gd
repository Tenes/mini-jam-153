extends Node2D
class_name Interactable

@onready var hitbox: Area2D = $Hitbox;
@export var startSuccess: int = 0;
@export var lengthSuccess: int = 10;
@onready var sprite: Sprite2D = $Sprite
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var secondary_sound_player_2d = $SecondarySoundPlayer2D
@export var capture_particles : Array[PackedScene]
@export var destruction_particles : Array[PackedScene]
@onready var animation_player = $AnimationPlayer

const direction : Array[int] = [-1, 1];
const scales : Array[float] = [0.25, 0.5, 2, 3];

var moovement: int = 1;
var moovementModifier : float = 1;
var tween: Tween;
@export var scoreValue: int = 0;
var parent: Node2D;
var difficultyMultiplier: float = 1.0

func _process(delta: float) -> void:
	global_position.x += (moovement * moovementModifier * delta * 100 * difficultyMultiplier);

func spawnFrom(from: Node2D, multiplier: float, movementModifier: float) -> void:
	moovementModifier = movementModifier;
	difficultyMultiplier = multiplier;
	parent = from;
	parent.add_child(self);
	global_position = from.global_position

func bindTo(from: Node2D) -> void:
	moovement = 0;
	deactivateAllAreas();
	animation_player.queue_free()
	if parent != null:
		self.reparent(from);
	parent = from;
	var newPos = Vector2(Global.RNG.randi_range(int(from.global_position.x) - 20, int(from.global_position.x) + 5),\
						(Global.RNG.randi_range(int(from.global_position.y) - 10, int(from.global_position.y) + 30)));
	global_position = newPos;
	if self is Building:
		tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR);
		tween.tween_property(sprite, "scale", Vector2(0.25, 0.25), 0.25).set_trans(Tween.TRANS_LINEAR).from_current();
	playCaptSound();

func deactivateCaptureArea() -> void:
	hitbox.collision_layer = 2;

func deactivateAllAreas() -> void:
	hitbox.free();
	
func failedCaptureAnimation() -> void:
	instantiate_particles(destruction_particles,Vector2.UP * 10,get_tree().root)
	var failedDuration = Global.RNG.randf_range(0.1, 1);
	var scaleValue = scales.pick_random();
	tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR);
	tween.tween_property(self, "global_position", Vector2(Global.RNG.randi_range(-200, 600), -200), failedDuration).set_trans(Tween.TRANS_LINEAR).from_current();
	tween.parallel().tween_property(sprite, "rotation", direction.pick_random() * 3000, failedDuration).set_trans(Tween.TRANS_LINEAR).from_current();
	tween.parallel().tween_property(sprite, "scale", Vector2(scaleValue, scaleValue), failedDuration).set_trans(Tween.TRANS_LINEAR).from_current();
	playDeathSound();
	await get_tree().create_timer(1).timeout;
	queue_free();
	
func playDeathSound() -> void:
	if self is Building:
		audio_stream_player_2d.stream = Global.BUILDING_DEATH_SOUNDS.pick_random();
	elif self is Car:
		audio_stream_player_2d.stream = Global.CAR_DEATH_SOUNDS.pick_random();
		audio_stream_player_2d.pitch_scale = Global.RNG.randf_range(0.9, 1.1);
	else:
		audio_stream_player_2d.stream = Global.HUMAN_DEATH_SOUNDS.pick_random();
		secondary_sound_player_2d.stream = Global.BLOOD_SOUNDS.pick_random();
	audio_stream_player_2d.pitch_scale = Global.RNG.randf_range(0.8, 1.3);
	audio_stream_player_2d.play();
	secondary_sound_player_2d.play()

func playCaptSound() -> void:
	if self is Building:
		audio_stream_player_2d.stream = Global.BUILDING_CAPT_SOUNDS.pick_random();
		audio_stream_player_2d.pitch_scale = Global.RNG.randf_range(0.8, 0.9);
	elif self is Car:
		audio_stream_player_2d.stream = Global.CAR_CAPT_SOUNDS.pick_random();
		audio_stream_player_2d.pitch_scale = Global.RNG.randf_range(0.5, 0.7);
	else:
		audio_stream_player_2d.stream = Global.HUMAN_CAPT_SOUNDS.pick_random();
		audio_stream_player_2d.pitch_scale = Global.RNG.randf_range(0.8, 1.3);
	audio_stream_player_2d.play();
	await audio_stream_player_2d.finished
	audio_stream_player_2d.queue_free()

func instantiate_particles(particle_list,offset = Vector2.ZERO, pparent = self) -> void:
	if particle_list == null:
		return
	for particle in particle_list:
		var instance = particle.instantiate() as CPUParticles2D
		instance.emitting = true
		instance.finished.connect(func():instance.queue_free())
		
		pparent.add_child(instance)
		instance.global_position = global_position + offset
	
func is_captured(success_state : Global.BarStatus) -> void:
	if success_state == Global.BarStatus.SUCCESS or success_state == Global.BarStatus.GREAT_SUCCESS:
		instantiate_particles(capture_particles)
	if Events.bar_clicked.is_connected(self.is_captured):
		Events.bar_clicked.disconnect(self.is_captured)
