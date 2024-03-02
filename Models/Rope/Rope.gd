extends Line2D
class_name Rope

var linkedHarpoon : Harpoon;

func linkToHarpoon(harpoon: Harpoon) -> void:
	width = 2;
	add_point(Vector2(0, 0));
	add_point(harpoon.getRopeHolePoint());
	linkedHarpoon = harpoon;

func update() -> void:
	self.points[1] = linkedHarpoon.getRopeHolePoint();
