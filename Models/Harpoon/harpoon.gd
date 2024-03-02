extends Node2D
class_name Harpoon

@onready var ropeHole = $SpriteMiddle/RopeHole;
var interactables : Array[Interactable] = [];

func _ready() -> void:
	Events.bar_clicked.connect(removeInteractable);

func _process(delta: float) -> void:
	pass


func getRopeHolePoint() -> Vector2 : 
	return ropeHole.global_position;

func removeInteractable(status):
	if self.interactables.size() > 0:
		if status == Global.BarStatus.SUCCESS:
			self.interactables.pop_front().queue_free();
			if self.interactables.size() > 0:
				var tempInteractables = self.interactables[0];
				Events.on_interactable_collided.emit(tempInteractables.startSuccess, tempInteractables.lengthSuccess);
		elif status == Global.BarStatus.GREAT_SUCCESS:
			pass;
		else:
			pass;

func _on_hitbox_area_entered(area: Area2D):
	var parent: Interactable = area.get_parent();
	self.interactables.append(parent);
	if self.interactables.size() == 1:
		Events.on_interactable_collided.emit(parent.startSuccess, parent.lengthSuccess);
