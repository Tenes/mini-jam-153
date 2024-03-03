extends Node

@onready var RNG = RandomNumberGenerator.new();
@onready var INTERACTABLES = [
	preload("res://Models/Human/human.tscn"),
	preload("res://Models/Building/building.tscn"),
	preload("res://Models/Building/building_2.tscn"),
	preload("res://Models/Car/car.tscn")
]
@onready var SCENES = {
	1: "res://Scenes/city_scene.tscn",
	2: "res://Scenes/main_menu_scene.tscn",
	3: "res://Scenes/credit_scene.tscn",
}

@onready var HUMAN_DEATH_SOUNDS = [
	preload("res://Assets/Sounds/human_death.mp3"),
	preload("res://Assets/Sounds/human_death_2.mp3"),
	preload("res://Assets/Sounds/human_death_3.mp3"),
]

@onready var BLOOD_SOUNDS = [
	preload("res://Assets/Sounds/blood_explosion_1.mp3"),
	preload("res://Assets/Sounds/blood_explosion_2.mp3")
]

@onready var BUILDING_DEATH_SOUNDS = [
	preload("res://Assets/Sounds/building_death.mp3"),
	preload("res://Assets/Sounds/building_death_2.mp3"),
	preload("res://Assets/Sounds/building_death_3.mp3"),
]
@onready var HUMAN_CAPT_SOUNDS = [
	preload("res://Assets/Sounds/human_capture.mp3"),
	preload("res://Assets/Sounds/human_capture_2.mp3"),
	preload("res://Assets/Sounds/human_capture_3.mp3"),
]

@onready var BUILDING_CAPT_SOUNDS = [
	preload("res://Assets/Sounds/building_capture_3.mp3"),
	preload("res://Assets/Sounds/building_capture_2.mp3"),
	preload("res://Assets/Sounds/building_capture_3.mp3"),
]

@onready var CAR_CAPT_SOUNDS = [
	preload("res://Assets/Sounds/car_capture_3.mp3"),
	preload("res://Assets/Sounds/car_capture_2.mp3")
]

@onready var CAR_DEATH_SOUNDS = [
	preload("res://Assets/Sounds/car_death_1.mp3")
]

@onready var ALL_SOUNDS = [
	preload("res://Assets/Sounds/human_death.mp3"),
	preload("res://Assets/Sounds/human_death_2.mp3"),
	preload("res://Assets/Sounds/human_death_3.mp3"),
	preload("res://Assets/Sounds/blood_explosion_1.mp3"),
	preload("res://Assets/Sounds/blood_explosion_2.mp3"),
	preload("res://Assets/Sounds/building_death.mp3"),
	preload("res://Assets/Sounds/building_death_2.mp3"),
	preload("res://Assets/Sounds/building_death_3.mp3"),
	preload("res://Assets/Sounds/human_capture.mp3"),
	preload("res://Assets/Sounds/human_capture_2.mp3"),
	preload("res://Assets/Sounds/human_capture_3.mp3"),
	preload("res://Assets/Sounds/building_capture_2.mp3"),
	preload("res://Assets/Sounds/building_capture_3.mp3"),
	preload("res://Assets/Sounds/car_capture_3.mp3"),
	preload("res://Assets/Sounds/car_death_1.mp3")
]

@onready var ALL_PARTICLES = [
	preload("res://Models/Particles/blood_particle_2d.tscn"),
	preload("res://Models/Particles/brutal_particle_2d.tscn"),
	preload("res://Models/Particles/capture_particles.tscn"),
	preload("res://Models/Particles/capture_particles_explosion01.tscn")
	]

enum BarStatus {
	DEFAULT = 0,
	SUCCESS = 1,
	GREAT_SUCCESS = 2,
	FAILED = 3
}
