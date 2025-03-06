extends ProgressBar

class_name HealthBar2D

@export var health_compnent: HealthComponent

@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("player")


func _ready() -> void:
	print(health_compnent)
	if health_compnent:
		value = health_compnent.health
		max_value = health_compnent.max_health
		health_compnent.damage_taken.connect(_on_damage_taken)

func _on_damage_taken(dmg):
	value = health_compnent.health
	
func set_health(health: HealthComponent):
	health_compnent = health
	print(health_compnent)
	_ready()
