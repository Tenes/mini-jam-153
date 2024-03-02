extends Node2D
class_name Harpoon

@onready var ropeHole = $SpriteMiddle/RopeHole;
@onready var originalPosition: Vector2 = global_position;
var interactables : Array[Interactable] = [];
var tween: Tween;
var currentState : Global.BarStatus;
var isReeling: bool = false;
var baseGap: int = 3;
const CAPTUREG_GAP: int = 3;
var hp: int = 3;

func _ready() -> void:
	Events.bar_clicked.connect(removeInteractable);

func _process(delta: float) -> void:
	pass


func getRopeHolePoint() -> Vector2 : 
	return ropeHole.global_position;

func removeInteractable(status):
	currentState = status;
	if !isReeling && interactables.size() > 0:
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
	tween.tween_property(self, "global_position", Vector2(global_position.x - 200, global_position.y), 2).from_current();
	#tween.tween_property(self, "global_position", Vector2(originalPosition.x - 50, originalPosition.y), 1).from_current();

func returnToOriginalPosition() -> void:
	tween.stop();
	tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR);
	tween.tween_property(self, "global_position", Vector2(originalPosition.x, originalPosition.y), 0.5).from_current();
	isReeling = false;

func _on_scanbox_area_entered(area: Area2D) -> void:
	if self.interactables.size() > 0:
		if currentState == Global.BarStatus.SUCCESS:
			var capturedInteractable = self.interactables.pop_front()
			Events.update_score.emit(capturedInteractable.scoreValue);
			capturedInteractable.bindTo(self, self.baseGap);
			self.baseGap += CAPTUREG_GAP;
			if self.interactables.size() > 0:
				var tempInteractables = self.interactables[0];
				Events.on_interactable_collided.emit(tempInteractables.startSuccess, tempInteractables.lengthSuccess);
		elif currentState == Global.BarStatus.GREAT_SUCCESS:
			pass;
		else:
			self.interactables.pop_front();
			Events.update_durability.emit(-1);
	currentState = Global.BarStatus.DEFAULT;
	returnToOriginalPosition();
