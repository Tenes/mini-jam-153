extends Node2D
class_name  ParallaxContainerNode2D

@export var offset : Vector2;
@export var speed : float = 100;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	offset.x += speed * delta;
	pass
