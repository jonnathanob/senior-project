extends Node

@onready var finish_line: FinishLine = $"../FinishLine"
@onready var ui: UI = $"../UI"
var player: Player

func _ready() -> void:
	finish_line.level_won.connect(_on_level_won)
	player = get_tree().get_first_node_in_group("player")
	
func _on_level_won():
	player.linear_velocity = Vector3.ZERO
	player.freeze = true
	ui.on_level_won()
	LevelManager.unlock_level(2)
