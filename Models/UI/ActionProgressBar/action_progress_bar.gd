extends ProgressBar
@export var base_speed = 200.0
var current_speed = 0
var current_start_pourcentage = -1
var current_pourcentage = -1
@onready var area_container = $AreaContainer

func _ready():
	Events.on_interactable_collided.connect(set_capture_area)

func _process(delta):
	value += current_speed * delta
	if value == 100 or value == 0:
		current_speed *= -1
	%VSeparator.position.x = value/max_value * size.x

func set_capture_area(start_pourcentage, pourcentage):
	reset()
	current_speed = base_speed
	current_start_pourcentage = start_pourcentage
	current_pourcentage = pourcentage
	clear_capture_area()
	var rec = ColorRect.new()
	rec.color = Color.FOREST_GREEN
	rec.size = Vector2(pourcentage/100.0 * size.x,size.y)
	rec.position = Vector2(start_pourcentage/100.0 * size.x,0)
	area_container.add_child(rec)
	
func clear_capture_area():
	for child in area_container.get_children():
		child.queue_free()

func _unhandled_input(event):
	if Input.is_action_just_pressed("left_click") and current_pourcentage > -1:
		if value >= current_start_pourcentage and value <= current_start_pourcentage+current_pourcentage:
			clear_capture_area()
			reset()
			Events.bar_clicked.emit(Global.BarStatus.SUCCESS)
		else:
			reset(base_speed)
			Events.bar_clicked.emit(Global.BarStatus.FAILED)

func reset(speed = 0):
	value = 0
	current_speed = speed
