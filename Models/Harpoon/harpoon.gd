extends Node2D
class_name Harpoon

@onready var RopeHole = $SpriteMiddle/RopeHole;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func getRopeHolePoint() -> Vector2 : 
	return RopeHole.global_position;
