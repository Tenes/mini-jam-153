extends Node2D

@onready var rope : Rope = $Rope;
@onready var harpoon : Harpoon = $Harpoon;
@onready var interactableContainer : Node2D = $InteractableContainer;
var interactables : Array[Interactable] = [];

func _ready() -> void:
	rope.linkToHarpoon(harpoon);

func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("right_click"):
		var tempInteractable = Global.INTERACTABLES[Global.RNG.randi_range(1, 2)].instantiate();
		tempInteractable.spawnFrom(interactableContainer);
		interactables.append(tempInteractable);
		
