extends RigidBody3D

@export var fall_down_distance = 30
@onready var particle_system = $GPUParticles3D
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

var player

func _ready() -> void:
	gravity_scale = 0
	player = get_tree().get_first_node_in_group("player")

func _process(delta: float) -> void:
	var player_z_vector = Vector3(0, 0, player.position.z)
	var obstacle_z_vector = Vector3(0, 0, position.z)
	var distance = player_z_vector.distance_to(obstacle_z_vector)
	
	if distance < fall_down_distance:
		gravity_scale = 1


func _on_body_entered(body: Node) -> void:
	print(body is Floor)
	if body is Floor:
		particle_system.emitting = true
		audio_stream_player_3d.play()
