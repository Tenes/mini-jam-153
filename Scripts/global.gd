extends Node

@onready var RNG = RandomNumberGenerator.new();
@onready var INTERACTABLES = {
	1: preload("res://Models/Human/human.tscn"),
	2: preload("res://Models/Building/building.tscn"),
}
@onready var SCENES = {
	1: "res://Scenes/city_scene.tscn",
	2: "res://Scenes/main_menu_scene.tscn",
	3: "res://Scenes/credit_scene.tscn",
}

enum BarStatus {
	DEFAULT = 0,
	SUCCESS = 1,
	GREAT_SUCCESS = 2,
	FAILED = 3
}
