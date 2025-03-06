extends CanvasLayer

signal restart
signal resume

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_on_resume_pressed()
		get_tree().get_root().set_input_as_handled()
		

func _on_restart_pressed() -> void:
	restart.emit()
	get_tree().paused = false
	get_tree().reload_current_scene()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_resume_pressed() -> void:
	resume.emit()
