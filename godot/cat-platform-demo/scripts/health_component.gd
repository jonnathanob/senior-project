extends Node

class_name HealthComponent

@export var max_health: int

var health: int

signal damage_taken(damage: int)
signal health_healed
signal death

func _ready() -> void:
	health = max_health
	print(health)

func damage(dmg: int) -> void:
	health -= dmg
	damage_taken.emit(dmg)
	
	if health <= 0:
		death.emit()
		var parent = get_parent()
		if not (parent is Player):
			parent.queue_free()
		else:
			parent.hide()
