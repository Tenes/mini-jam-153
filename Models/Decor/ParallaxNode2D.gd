extends Node2D

@export var offset_scale : Vector2
@export var repeat : Vector2i

var child : Node2D
var container : ParallaxContainerNode2D
var children = []
# Called when the node enters the scene tree for the first time.
func _ready():
	child = get_child(0)
	var left_child = child.duplicate()
	var right_child = child.duplicate()
	
	if repeat != Vector2i.ZERO:
		
		add_child(left_child)
		add_child(right_child)
		left_child.position = child.position - Vector2(repeat)
		right_child.position = child.position + Vector2(repeat)
	
	container = get_parent()
	pass # Replace with function body.

func _process(_delta):
	position = Vector2(fmod(container.offset.x * offset_scale.x, repeat.x), position.y)

