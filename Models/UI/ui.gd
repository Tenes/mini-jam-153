extends Control
@onready var health_bar: TextureRect = $HealthBar
@onready var score_value: Label = $ScoreContainer/ScoreValue
@onready var score_multiplier: Label = $MultiplerHolder/ScoreMultiplier
@onready var animation_player: AnimationPlayer = $MultiplerHolder/AnimationPlayer
@onready var progress_bar_animation_player: AnimationPlayer = $MarginContainer/ProgressBarAnimationPlayer
@onready var floating_score: Label = $FloatingTextContainer/FloatingScore
@onready var fishing_rod = $FishingRod
@onready var health_animation: AnimationPlayer = $HealthBar/HealthAnimation

var tween: Tween;
var score = 0;
var scoreMultiplier = 1;
var bestScoreMultiplier = 1;
var health: int = 3;

func _ready() -> void:
	updateScore(0);
	updateMultiplier(false);
	Events.update_durability.connect(updateDurability);
	Events.update_score.connect(updateScore);
	Events.update_multiplier.connect(updateMultiplier);
	Events.bar_clicked.connect(shakeProgressBar);

func updateDurability(value: int) -> void:
	health += value;
	tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR);
	tween.tween_property(health_bar, "size", Vector2(health_bar.size.x - ((3 - health)*32), health_bar.size.y), 0.3).set_ease(Tween.EASE_OUT).from_current();
	health_animation.play("blink");
	if health == 0:
		await get_tree().create_timer(0.25).timeout;
		Events.player_death.emit(score, bestScoreMultiplier);

func updateScore(value: int) -> void:
	score += value * scoreMultiplier;
	score_value.text = str(score);
	if score != 0:
		floating_score.text = "+%s"%(value * scoreMultiplier);
		tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR);
		var textContainer = floating_score.get_parent();
		tween.tween_property(textContainer, "scale", Vector2(1, 1), 0.2).set_ease(Tween.EASE_OUT).from_current();
		await tween.finished;
		tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR);
		tween.tween_property(textContainer, "scale", Vector2(0, 0), 0.4).set_ease(Tween.EASE_OUT).from_current();
		await tween.finished;
		floating_score.text = "";
	

func updateMultiplier(isSuccess: bool) -> void:
	if isSuccess:
		scoreMultiplier += 1;
		animation_player.play("upgrade");
	else:
		if scoreMultiplier > bestScoreMultiplier:
			bestScoreMultiplier = scoreMultiplier;
		scoreMultiplier = 1;
	score_multiplier.text = str(scoreMultiplier);

func shakeProgressBar(status) -> void:
	var ttween = create_tween()
	ttween.tween_property(fishing_rod,"scale",Vector2(1.5,1.5),0.2)
	ttween.tween_property(fishing_rod,"scale",Vector2(1,1),0.2)
	if status == Global.BarStatus.GREAT_SUCCESS:
		progress_bar_animation_player.play("shake_great_success");
	elif status == Global.BarStatus.SUCCESS:
		progress_bar_animation_player.play("shake_success");
	else:
		progress_bar_animation_player.play("shake_failed");
