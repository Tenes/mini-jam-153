extends Node2D


@onready var Rope : Rope = $Rope
@onready var Harpoon : Harpoon = $Harpoon

func _ready() -> void:
	Rope.linkToHarpoon(Harpoon);

func _process(delta: float) -> void:
	pass
