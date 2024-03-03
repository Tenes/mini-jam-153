extends Node
@onready var game_screen: Node = $GameScreen
@onready var end_screen: Control = $EndScreen
@onready var rope : Rope = $GameScreen/Rope;
@onready var harpoon : Harpoon = $GameScreen/Harpoon;
@onready var interactableContainer : Node2D = $GameScreen/InteractableContainer;
@onready var waveTimer: Timer = $GameScreen/WaveTimer
@onready var spawnTimer: Timer = $GameScreen/SpawnTimer
@onready var final_score: Label = $EndScreen/HBoxContainer/VBoxContainer/FinalScore
@onready var final_multiplier: Label = $EndScreen/HBoxContainer/VBoxContainer/FinalMultiplier
@onready var hidden_multiplicator: Label = $EndScreen/HBoxContainer/VBoxContainer/HiddenMultiplicator
@export var waveDownTimer: float = 2;
var interactables : Array[Interactable] = [];
var difficultyMultiplier:  = 1.0;
const waveTimerSpawnRate : Array[float] = [0.8, 1, 1.25];
const waveDifficulty : Array[float] = [0.75, 1.25, 3];
const waveDuration: float = 10;
var currentWaveDifficulty : float;

func _ready() -> void:
	Events.update_score.connect(updateDifficultyMultiplier);
	Events.player_death.connect(displayEndScreen);
	rope.linkToHarpoon(harpoon);
	setupWaveTimer();
#ADD SPOOF PARTICLES HERE TO LOAD THEM 
	for n in 12 :
		var tempAudioStream : AudioStreamPlayer = AudioStreamPlayer.new();
		tempAudioStream.stream = Global.ALL_SOUNDS[n];
		tempAudioStream.volume_db = -80;
		add_child(tempAudioStream);
		tempAudioStream.play();
		tempAudioStream.finished.connect(tempAudioStream.queue_free);

func updateDifficultyMultiplier(value: float):
	difficultyMultiplier += (value/10000);

func interactableSpawner() -> void:
	var tempInteractable = Global.INTERACTABLES[Global.RNG.randi_range(1, 2)].instantiate();
	tempInteractable.spawnFrom(interactableContainer, difficultyMultiplier, currentWaveDifficulty);
	interactables.append(tempInteractable);

func displayEndScreen(finalScore, bestMultiplier) -> void:
	game_screen.queue_free();
	end_screen.show();
	final_score.text = str(finalScore);
	final_multiplier.text = final_multiplier.text%bestMultiplier;
	hidden_multiplicator.text = hidden_multiplicator.text%str(snapped(difficultyMultiplier, 0.001));

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file(Global.SCENES[2]);

func setupWaveTimer() -> void:
	if waveTimer.timeout.is_connected(setupWaveTimer):
		waveTimer.timeout.disconnect(setupWaveTimer);
	spawnTimer.stop();
	waveTimer.stop();
	waveTimer.wait_time = waveDownTimer;
	waveTimer.timeout.connect(waveSpawner);
	waveTimer.start();
	waveTimer.one_shot = true;

func waveSpawner() -> void:
	var waveSelection = Global.RNG.randi_range(0, 2);
	spawnTimer.wait_time = waveTimerSpawnRate[waveSelection];
	if spawnTimer.timeout.is_connected(interactableSpawner):
		spawnTimer.timeout.disconnect(interactableSpawner);
	spawnTimer.timeout.connect(interactableSpawner);
	spawnTimer.start();
	currentWaveDifficulty = waveDifficulty[waveSelection];
	waveTimer.stop();
	waveTimer.wait_time = waveDuration;
	if waveTimer.timeout.is_connected(waveSpawner):
		waveTimer.timeout.disconnect(waveSpawner);
	waveTimer.timeout.connect(setupWaveTimer);
	waveTimer.one_shot = true;
	waveTimer.start();
