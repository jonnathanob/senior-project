extends Node3D

class_name MainCat

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func walk():
	animation_player.play("walking")
	animation_player.speed_scale = 2

func idle():
	animation_player.stop()
