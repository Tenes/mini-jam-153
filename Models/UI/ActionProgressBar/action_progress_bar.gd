extends ProgressBar
@export var base_speed = 200.0
@export var great_success_divider = 6.0
var current_speed = 0
var current_start_pourcentage = -1
var current_pourcentage = -1
@onready var area_container = $AreaContainer
@onready var audio_stream_player = $AudioStreamPlayer
@onready var great_success_particle = $VSeparator/GreatSuccessParticle

const GREAT_SUCCESS_1 = preload("res://Assets/Sounds/great_success_1.mp3")
const SUCCESS_1 = preload("res://Assets/Sounds/success_1.mp3")
const FAILURE_1 = preload("res://Assets/Sounds/failure_1.mp3")
func _ready():
	Events.on_interactable_collided.connect(set_capture_area)
	Events.reset_bar.connect(reset)

func _process(delta):
	value += current_speed * delta
	if value == 100 or value == 0:
		current_speed *= -1
	%VSeparator.position.x = value/max_value * size.x - %VSeparator.size.x /2

func set_capture_area(start_pourcentage, pourcentage):
	clear_capture_area()
	current_speed = base_speed
	current_start_pourcentage = start_pourcentage
	current_pourcentage = pourcentage
	var rec = ColorRect.new()
	rec.mouse_filter = Control.MOUSE_FILTER_IGNORE;
	rec.color = Color.FOREST_GREEN
	rec.color.a8 = 180;
	rec.size = Vector2(pourcentage/100.0 * size.x,size.y)
	rec.position = Vector2(start_pourcentage/100.0 * size.x,0)
	var great_rec = ColorRect.new()
	great_rec.mouse_filter = Control.MOUSE_FILTER_IGNORE;
	great_rec.color = Color.GOLD
	great_rec.color.a8 = 200;
	var great_rec_size = pourcentage/great_success_divider
	great_rec.size = Vector2(great_rec_size/100.0 * size.x,size.y)
	great_rec.position = Vector2(start_pourcentage/100.0 * size.x + (pourcentage/100.0 * size.x/2) - great_rec_size/100.0 * size.x/2 ,0)
	area_container.add_child(rec)
	area_container.add_child(great_rec)
	
func clear_capture_area():
	for child in area_container.get_children():
		child.queue_free()

func _unhandled_input(event):
	if event.is_action_pressed("left_click") and current_pourcentage > -1:
		if value >= current_start_pourcentage and value <= current_start_pourcentage+current_pourcentage:
			var great_value = current_start_pourcentage+current_pourcentage*0.5
			if value >= great_value - current_pourcentage / great_success_divider /2.0 and  value <= great_value + current_pourcentage / great_success_divider /2.0:
				spawn_great_success_particle()
				reset()
				audio_stream_player.stream = GREAT_SUCCESS_1
				Events.bar_clicked.emit(Global.BarStatus.GREAT_SUCCESS)
			else :
				audio_stream_player.stream = SUCCESS_1
				reset()
				Events.bar_clicked.emit(Global.BarStatus.SUCCESS)
		else:
			audio_stream_player.stream = FAILURE_1
			Events.bar_clicked.emit(Global.BarStatus.FAILED)
		audio_stream_player.play()

func reset(speed = 0):
	clear_capture_area();
	value = 0
	current_pourcentage = -1
	current_speed = speed

func spawn_great_success_particle():
	var instance = great_success_particle.duplicate(DUPLICATE_USE_INSTANTIATION)
	add_child(instance)
	instance.global_position = great_success_particle.global_position
	instance.finished.connect(func():instance.queue_free())
	instance.emitting = true
	
