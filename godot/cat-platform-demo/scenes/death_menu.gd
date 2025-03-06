extends CanvasLayer

signal restart

func _on_restart_pressed() -> void:
	restart.emit()
	get_tree().paused = false
	get_tree().reload_current_scene()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_quit_pressed() -> void:
	get_tree().quit()
