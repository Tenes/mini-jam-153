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

@onready var HUMAN_SOUNDS = {
	1: preload("res://Assets/Sounds/human_death.mp3"),
	2: preload("res://Assets/Sounds/human_death_2.mp3"),
	3: preload("res://Assets/Sounds/human_death_3.mp3"),
}

@onready var BUILDING_SOUNDS = {
	1: preload("res://Assets/Sounds/building_death.mp3"),
	2: preload("res://Assets/Sounds/building_death_2.mp3"),
}

enum BarStatus {
	DEFAULT = 0,
	SUCCESS = 1,
	GREAT_SUCCESS = 2,
	FAILED = 3
}
