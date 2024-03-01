extends Node

@onready var rng = RandomNumberGenerator.new();
@onready var Humans = {
	1: preload("res://Models/Human/human.tscn"),
}
@onready var Buildings = {
	1: preload("res://Models/Building/building.tscn"),
}

#func _ready() -> void:
