extends Node3D

@export var health_component: HealthComponent
@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("player")
@onready var health_bar_2d: HealthBar2D = $SubViewport/HealthBar2D

func _ready() -> void:
	# only display when theres a player in the scene
	if not player:
		queue_free()
	
	health_bar_2d.set_health(health_component)
