extends CharacterBody3D

class_name EnemyDummy

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var cat: CharacterBody3D = get_tree().get_first_node_in_group("player")
@onready var attack_timer: Timer = $AttackTimer
@onready var attachhitbox: Area3D = $attachhitbox
@onready var move_timer: Timer = $MoveTimer

@export var speed := 5

var direction := Vector3.ZERO
var _gravity = -30

var _follow = false

func _has_player(body: Node3D):
	return body is Player
	

func _physics_process(delta: float) -> void:
	if _follow:
		navigation_agent_3d.set_target_position(cat.global_transform.origin)
		var current_location = global_transform.origin
		var next_location = navigation_agent_3d.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * speed 
		
		velocity = velocity.move_toward(new_velocity, speed)
		rotation.y = lerp_angle(rotation.y, atan2(-velocity.x, -velocity.z), 0.01)
		
		if navigation_agent_3d.is_target_reachable() and attachhitbox.get_overlapping_bodies().any(_has_player) and attack_timer.is_stopped():
			attack_timer.start()
	else:
		var y_velocity = velocity.y
		velocity.y = 0
		velocity = velocity.move_toward(direction * speed, delta)
		velocity.y = y_velocity + _gravity * delta
	move_and_slide()

func _on_follow_area_body_entered(body: Node3D) -> void:
	if body is Player:
		_follow = true


func _on_follow_area_body_exited(body: Node3D) -> void:
	if body is Player:
		_follow = false


func _on_timer_timeout() -> void:
	var has_player = attachhitbox.get_overlapping_bodies().any(_has_player)
	if (has_player and attachhitbox.get_overlapping_areas().size() > 0):
		print(attachhitbox.get_overlapping_areas())
		var e = attachhitbox.get_overlapping_areas()[-1] as HitboxComponent
		e.damage(10)
		


func _on_move_timer_timeout() -> void:
	move_timer.wait_time = [1,1.5,2,2.5].pick_random()
	direction = [Vector3.BACK, Vector3.FORWARD, Vector3.LEFT, Vector3.RIGHT].pick_random()
