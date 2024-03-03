extends Node
@onready var game_screen: Node = $GameScreen
@onready var end_screen: Control = $EndScreen
@onready var rope : Rope = $GameScreen/Rope;
@onready var harpoon : Harpoon = $GameScreen/Harpoon;
@onready var interactableContainer : Node2D = $GameScreen/InteractableContainer;
@onready var timer: Timer = $GameScreen/Timer
@onready var final_score: Label = $EndScreen/HBoxContainer/VBoxContainer/FinalScore
@onready var final_multiplier: Label = $EndScreen/HBoxContainer/VBoxContainer/FinalMultiplier
@onready var hidden_multiplicator: Label = $EndScreen/HBoxContainer/VBoxContainer/HiddenMultiplicator
@export var spawnTimer: float = 1;
var interactables : Array[Interactable] = [];
var difficultyMultiplier:  = 1.0;

func _ready() -> void:
	Events.update_score.connect(updateDifficultyMultiplier);
	Events.player_death.connect(displayEndScreen);
	rope.linkToHarpoon(harpoon);
	interactableSpawner();
	timer.start();

func updateDifficultyMultiplier(value: float):
	difficultyMultiplier += (value/10000);

func interactableSpawner() -> void:
	var tempInteractable = Global.INTERACTABLES[Global.RNG.randi_range(1, 2)].instantiate();
	tempInteractable.spawnFrom(interactableContainer, difficultyMultiplier);
	interactables.append(tempInteractable);

func _on_timer_timeout() -> void:
	interactableSpawner();

func displayEndScreen(finalScore, bestMultiplier) -> void:
	game_screen.queue_free();
	end_screen.show();
	final_score.text = str(finalScore);
	final_multiplier.text = final_multiplier.text%bestMultiplier;
	hidden_multiplicator.text = hidden_multiplicator.text%str(snapped(difficultyMultiplier, 0.001));

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file(Global.SCENES[2]);
