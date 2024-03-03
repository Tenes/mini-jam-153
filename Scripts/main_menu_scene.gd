extends CanvasLayer

func _ready() -> void:
	for n in 12 :
		var tempAudioStream : AudioStreamPlayer = AudioStreamPlayer.new();
		tempAudioStream.stream = Global.ALL_SOUNDS[n];
		tempAudioStream.volume_db = -80;
		add_child(tempAudioStream);
		tempAudioStream.play();
		tempAudioStream.finished.connect(tempAudioStream.queue_free);

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file(Global.SCENES[1]);

func _on_credit_pressed() -> void:
	get_tree().change_scene_to_file(Global.SCENES[3]);

func _on_exit_pressed() -> void:
	get_tree().quit();

