extends CanvasLayer

class_name UI

@onready var label: Label = %Label
@onready var next_level: CenterContainer = $NextLevel

var time_passed = 0
var is_done = false

func _process(delta: float) -> void:
	if !is_done:
		time_passed += delta
		label.text = "%.2f" % time_passed
	
func on_level_won():
	is_done = true
	next_level.visible = true


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/level_select.tscn")
