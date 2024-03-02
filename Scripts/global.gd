extends Node

@onready var RNG = RandomNumberGenerator.new();
@onready var INTERACTABLES = {
	1: preload("res://Models/Human/human.tscn"),
	2: preload("res://Models/Building/building.tscn"),
}

enum BarStatus {
	DEFAULT = 0,
	SUCCESS = 1,
	GREAT_SUCCESS = 2,
	FAILED = 3
}
