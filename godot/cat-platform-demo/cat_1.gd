extends Node3D

class_name MainCat

@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal animation_finished(anim_name: StringName)

func walk():
	animation_player.play("walking", -1, 2)

func idle():
	animation_player.play("Idle", -1, .3)

func jump():
	animation_player.play("Jump_001")

func damage():
	animation_player.play("attack", -1, 3)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	animation_finished.emit(anim_name)
