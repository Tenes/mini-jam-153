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
@export var waveDownTimer: float = 1;
@onready var warning_panel = $WarningPanel

var interactables : Array[Interactable] = [];
var difficultyMultiplier:  = 1.0;
const waveTimerSpawnRate : Array[float] = [0.9, 1, 1, 1.5, 1.25];
const waveDifficulty : Array[float] = [0.75, 1, 1.25, 2.25, 1.75];
const waveLength: Array[float] = [30, 20, 15, 5, 12];
var currentWave: int;
var spawnedEnnemies: float;
var currentWaveLength: float;

func _ready() -> void:
	Events.update_score.connect(updateDifficultyMultiplier);
	Events.player_death.connect(displayEndScreen);
	Events.touched_prey.connect(updateRemainingWaveLength);
	rope.linkToHarpoon(harpoon);
	setupWaveTimer();
	spoof_particles()
	for n in Global.ALL_SOUNDS.size():
		var tempAudioStream : AudioStreamPlayer = AudioStreamPlayer.new();
		tempAudioStream.stream = Global.ALL_SOUNDS[n];
		tempAudioStream.volume_db = -80;
		add_child(tempAudioStream);
		tempAudioStream.play();
		tempAudioStream.finished.connect(tempAudioStream.queue_free);

func updateDifficultyMultiplier(value: float):
	difficultyMultiplier += (value/10000);

func interactableSpawner() -> void:
	if spawnedEnnemies < waveLength[currentWave] :
		var tempInteractable = Global.INTERACTABLES.pick_random().instantiate();
		tempInteractable.spawnFrom(interactableContainer, difficultyMultiplier, waveDifficulty[currentWave]);
		interactables.append(tempInteractable);
		spawnedEnnemies += 1;
	if spawnedEnnemies == waveLength[currentWave]:
		spawnTimer.stop();

func displayEndScreen(finalScore, bestMultiplier) -> void:
	game_screen.queue_free();
	end_screen.show();
	final_score.text = str(finalScore);
	final_multiplier.text = final_multiplier.text%bestMultiplier;
	hidden_multiplicator.text = hidden_multiplicator.text%str(snapped(difficultyMultiplier, 0.001));

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file(Global.SCENES[2]);

func setupWaveTimer() -> void:
	spawnedEnnemies = 0;
	if waveTimer.timeout.is_connected(waveSpawner):
		waveTimer.timeout.disconnect(waveSpawner);
	spawnTimer.stop();
	waveTimer.stop();
	waveTimer.wait_time = waveDownTimer;
	waveTimer.timeout.connect(waveSpawner);
	waveTimer.start();
	waveTimer.one_shot = true;

func waveSpawner() -> void:
	currentWave = Global.RNG.randi_range(0, waveLength.size() - 1);
	spawnTimer.wait_time = waveTimerSpawnRate[currentWave];
	if spawnTimer.timeout.is_connected(interactableSpawner):
		spawnTimer.timeout.disconnect(interactableSpawner);
	spawnTimer.timeout.connect(interactableSpawner);
	spawnTimer.start();
	currentWaveLength =  waveLength[currentWave];
	show_warning()

func show_warning():
	warning_panel.visible = true
	await get_tree().create_timer(3.0).timeout;
	warning_panel.visible = false

func updateRemainingWaveLength() -> void:
	currentWaveLength -= 1;
	if currentWaveLength == 0:
		setupWaveTimer();

func spoof_particles():
	var all_particles = get_tree().get_nodes_in_group("particles")
	for particle in all_particles:
		particle.emitting = true
	for instantiated_particle in Global.ALL_PARTICLES:
		var instance = instantiated_particle.instantiate() as GPUParticles2D
		get_tree().root.add_child(instance)
		instance.emitting = true
		instance.finished.connect(func():instance.queue_free())
		instance.global_position = $GameScreen/Camera2D.global_position;
	await get_tree().create_timer(1.0).timeout
	for particle in all_particles:
		particle.emitting = false
	

