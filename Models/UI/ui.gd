extends Control
@onready var health_bar: ProgressBar = $HealthBar
@onready var score_value: Label = $ScoreContainer/ScoreValue
var score = 0;

func _ready() -> void:
	updateScore(0);
	Events.update_durability.connect(updateDurability);
	Events.update_score.connect(updateScore);

func updateDurability(value: int) -> void:
	health_bar.value += value;

func updateScore(value: int) -> void:
	score += value;
	score_value.text = str(score);
