extends Control
@onready var health_bar: ProgressBar = $HealthBar
@onready var score_value: Label = $ScoreContainer/ScoreValue
@onready var score_multiplier: Label = $MultiplerHolder/ScoreMultiplier
@onready var animation_player: AnimationPlayer = $MultiplerHolder/AnimationPlayer
var tween: Tween;
var score = 0;
var scoreMultiplier = 1;

func _ready() -> void:
	updateScore(0);
	updateMultiplier(false);
	Events.update_durability.connect(updateDurability);
	Events.update_score.connect(updateScore);
	Events.update_multiplier.connect(updateMultiplier);

func updateDurability(value: int) -> void:
	health_bar.value += value;

func updateScore(value: int) -> void:
	score += value * scoreMultiplier;
	score_value.text = str(score);

func updateMultiplier(isSuccess: bool) -> void:
	if isSuccess:
		scoreMultiplier += 1;
		animation_player.play("upgrade");
	else:
		scoreMultiplier = 1;
	score_multiplier.text = str(scoreMultiplier);
	
