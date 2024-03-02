extends Node2D
class_name Harpoon

@onready var ropeHole = $SpriteMiddle/RopeHole;
@onready var originalPosition: Vector2 = global_position;
var interactables : Array[Interactable] = [];
var capturedInteractables : Array[Interactable] = [];
var tween: Tween;
var isReeling: bool = false;
var baseGap: int = 3;
const CAPTUREG_GAP: int = 3;
var hp: int = 3;

func _ready() -> void:
	Events.bar_clicked.connect(updateInteractable);

func _process(delta: float) -> void:
	pass


func getRopeHolePoint() -> Vector2 : 
	return ropeHole.global_position;

func updateInteractable(status):
	if interactables.size() > 0:
		var targetInteractable = self.interactables.pop_front()
		if status == Global.BarStatus.SUCCESS:
			self.capturedInteractables.append(targetInteractable);
			if self.interactables.size() > 0:
				var tempInteractables = self.interactables[0];
				Events.on_interactable_collided.emit(tempInteractables.startSuccess, tempInteractables.lengthSuccess);
		else:
			Events.update_durability.emit(-1);
		if !isReeling:
			playReelingAnimation();

func _on_hitbox_area_entered(area: Area2D):
	var parent: Interactable = area.get_parent();
	self.interactables.append(parent);
	parent.deactivateCaptureArea();
	if self.interactables.size() == 1:
		Events.on_interactable_collided.emit(parent.startSuccess, parent.lengthSuccess);

func playReelingAnimation() -> void:
	isReeling = true;
	tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR);
	tween.tween_property(self, "global_position", Vector2(global_position.x - 200, global_position.y), 1).from_current();

func returnToOriginalPosition() -> void:
	if tween != null:
		tween.stop();
	tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR);
	tween.tween_property(self, "global_position", Vector2(originalPosition.x, originalPosition.y), 0.5).from_current();
	isReeling = false;

func _on_scanbox_area_entered(area: Area2D) -> void:
	if self.capturedInteractables.size() > 0:
		var capturedInteractable = self.capturedInteractables.pop_front()
		Events.update_score.emit(capturedInteractable.scoreValue);
		capturedInteractable.bindTo(self, self.baseGap);
		self.baseGap += CAPTUREG_GAP;
	returnToOriginalPosition();
