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

@onready var HUMAN_DEATH_SOUNDS = {
	1: preload("res://Assets/Sounds/human_death.mp3"),
	2: preload("res://Assets/Sounds/human_death_2.mp3"),
	3: preload("res://Assets/Sounds/human_death_3.mp3"),
}

@onready var BLOOD_SOUNDS = [
	preload("res://Assets/Sounds/blood_explosion_1.mp3"),
	preload("res://Assets/Sounds/blood_explosion_2.mp3")
]

@onready var BUILDING_DEATH_SOUNDS = {
	1: preload("res://Assets/Sounds/building_death.mp3"),
	2: preload("res://Assets/Sounds/building_death_2.mp3"),
	3: preload("res://Assets/Sounds/building_death_3.mp3"),
}
@onready var HUMAN_CAPT_SOUNDS = {
	1: preload("res://Assets/Sounds/human_capture.mp3"),
	2: preload("res://Assets/Sounds/human_capture_2.mp3"),
	3: preload("res://Assets/Sounds/human_capture_3.mp3"),
}

@onready var BUILDING_CAPT_SOUNDS = {
	1: preload("res://Assets/Sounds/building_capture_3.mp3"),
	2: preload("res://Assets/Sounds/building_capture_2.mp3"),
	3: preload("res://Assets/Sounds/building_capture_3.mp3"),
}

enum BarStatus {
	DEFAULT = 0,
	SUCCESS = 1,
	GREAT_SUCCESS = 2,
	FAILED = 3
}


static func toggleNode(node: Node):
	if node.visible:
		node.hide()
		node.set_process(false);
		node.set_physics_process(false);
		node.set_process_input(false);
	else:
		node.show()
		node.set_process(true);
		node.set_physics_process(true);
		node.set_process_input(true);

static func hideNode(node: Node):
	node.hide()
	node.set_process(false);
	node.set_physics_process(false);
	node.set_process_input(false);

static func showNode(node: Node):
	node.show();
	node.set_process(true);
	node.set_physics_process(true);
	node.set_process_input(true);

