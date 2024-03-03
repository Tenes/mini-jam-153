extends CanvasLayer

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file(Global.SCENES[1]);

func _on_credit_pressed() -> void:
	get_tree().change_scene_to_file(Global.SCENES[3]);

func _on_exit_pressed() -> void:
	get_tree().quit();

