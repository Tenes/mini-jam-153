extends Line2D
class_name Rope

var linkedHarpoon : Harpoon;
@export var origin : Marker2D
func linkToHarpoon(harpoon: Harpoon) -> void:
	width = 2;
	add_point(origin.global_position);
	add_point(harpoon.getRopeHolePoint());
	linkedHarpoon = harpoon;

func _process(delta: float) -> void:
	self.points[1] = linkedHarpoon.getRopeHolePoint();
	self.points[0] = origin.global_position;
