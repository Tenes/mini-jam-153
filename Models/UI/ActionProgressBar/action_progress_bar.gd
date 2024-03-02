extends ProgressBar
@export var base_speed = 200.0
@export var current_speed = 100.0
var current_start_pourcentage = -1
var current_pourcentage = -1

func _ready():
	current_speed = base_speed
	Events.on_interactable_collided.connect(set_capture_area)

func _process(delta):
	value += current_speed * delta
	if value == 100 or value == 0:
		current_speed *= -1
	%VSeparator.position.x = value/max_value * size.x

func set_capture_area(start_pourcentage, pourcentage):
	current_start_pourcentage = start_pourcentage
	current_pourcentage = pourcentage
	clear_capture_area()
	var rec = ColorRect.new()
	rec.color = Color.FOREST_GREEN
	rec.size = Vector2(pourcentage/100.0 * size.x,size.y)
	rec.position = Vector2(start_pourcentage/100.0 * size.x,0)
	$AreaContainer.add_child(rec)
	
func clear_capture_area():
	for child in $AreaContainer.get_children():
		child.queue_free()

func _unhandled_input(event):
	if Input.is_action_just_pressed("left_click"):
		if value >= current_start_pourcentage and value <= current_start_pourcentage+current_pourcentage:
			clear_capture_area()
			Events.bar_clicked.emit(Global.BarStatus.SUCCESS)
			return
		Events.bar_clicked.emit(Global.BarStatus.FAILED)
