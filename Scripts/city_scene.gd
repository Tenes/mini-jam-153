extends Node

@onready var rope : Rope = $Rope;
@onready var harpoon : Harpoon = $Harpoon;
@onready var interactableContainer : Node2D = $InteractableContainer;
@onready var timer: Timer = $Timer
@export var spawnTimer: float = 1;
var interactables : Array[Interactable] = [];

func _ready() -> void:
	rope.linkToHarpoon(harpoon);
	interactableSpawner();
	timer.start();

func _process(delta: float) -> void:
	rope.update();

func interactableSpawner() -> void:
	var tempInteractable = Global.INTERACTABLES[Global.RNG.randi_range(1, 2)].instantiate();
	tempInteractable.spawnFrom(interactableContainer);
	interactables.append(tempInteractable);


func _on_timer_timeout() -> void:
	interactableSpawner();
