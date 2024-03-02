extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = get_tree().create_tween().set_loops()
	tween.tween_property(self,"position",Vector2.UP * 5,0.5).from_current()
	tween.tween_property(self,"position",Vector2.DOWN * 5,0.5).from_current()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
