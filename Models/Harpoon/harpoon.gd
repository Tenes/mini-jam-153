extends Node2D
class_name Harpoon

@onready var ropeHole = $SpriteMiddle/RopeHole;
@onready var originalPosition: Vector2 = global_position;
@onready var hitbox: Area2D = $Hitbox
@onready var sprite_front = $SpriteFront

var interactables : Array[Interactable] = [];
var capturedInteractables : Array[Interactable] = [];
var tween: Tween;
var isReeling: bool = false;

func _ready() -> void:
	var tempPos = hitbox.global_position;
	hitbox.top_level = true;
	hitbox.global_position = tempPos;
	Events.bar_clicked.connect(updateInteractable);

func getRopeHolePoint() -> Vector2 : 
	return ropeHole.global_position;

func updateInteractable(status):
	if interactables.size() > 0:
		var targetInteractable = self.interactables.pop_front()
		if status == Global.BarStatus.SUCCESS or status == Global.BarStatus.GREAT_SUCCESS:
			Events.update_multiplier.emit(status == Global.BarStatus.GREAT_SUCCESS);
			self.capturedInteractables.append(targetInteractable);
			refreshBar();
		if !isReeling:
			playReelingAnimation();

func _on_hitbox_area_entered(area: Area2D):
	var parent: Interactable = area.get_parent();
	self.interactables.append(parent);
	parent.deactivateCaptureArea();
	if self.interactables.size() == 1:
		Events.on_interactable_collided.emit(parent.startSuccess, parent.lengthSuccess);
		Events.bar_clicked.connect(parent.is_captured)

func playReelingAnimation() -> void:
	isReeling = true;
	sprite_front.speed_scale = 1.3
	tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR);
	tween.tween_property(self, "global_position", Vector2(global_position.x - 350, global_position.y), 0.35).from_current();

func returnToOriginalPosition() -> void:
	if tween and tween.is_running():
		tween.kill();
	sprite_front.speed_scale = 0.7
	tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR);
	tween.tween_property(self, "global_position", Vector2(originalPosition.x, originalPosition.y), 0.2).from_current();
	isReeling = false;

func _on_scanbox_area_entered(area: Area2D) -> void:
	var interactable = area.get_parent() as Interactable;
	if interactable not in self.capturedInteractables:
		if interactable in self.interactables:
			self.interactables.pop_front();
		interactable.failedCaptureAnimation();
		Events.reset_bar.emit();
		Events.update_durability.emit(-1);
		Events.update_multiplier.emit(false);
		Events.touched_prey.emit();
		refreshBar();
	if interactable in self.capturedInteractables:
		var capturedInteractable = self.capturedInteractables.pop_front()
		Events.update_score.emit(capturedInteractable.scoreValue);
		Events.touched_prey.emit();
		capturedInteractable.bindTo(self);
	returnToOriginalPosition();

func refreshBar() -> void:
	if self.interactables.size() > 0:
		var tempInteractables = self.interactables[0];
		Events.on_interactable_collided.emit(tempInteractables.startSuccess, tempInteractables.lengthSuccess);
