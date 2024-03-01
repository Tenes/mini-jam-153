extends Node2D


@onready var Rope : Line2D = $Rope
@onready var Harpoon : Harpoon = $Harpoon

func _ready() -> void:
	Rope.width = 2;
	Rope.add_point(Vector2(0, 0));
	Rope.add_point(Harpoon.getRopeHolePoint());


func _process(delta: float) -> void:
	pass
