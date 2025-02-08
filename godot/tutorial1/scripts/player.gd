extends RigidBody3D

var speed = 200
var input: Vector3 = Vector3.ZERO
var vertical_speed_increment = .1
var horizontal_speed_increment = .1
var JUMP_FORCE: int = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event):
	input = Vector3(Input.get_action_raw_strength("left") - Input.get_action_raw_strength("right"), 0, Input.get_action_raw_strength("forward") - Input.get_action_raw_strength("slow_down"))
	
	if Input.is_action_just_pressed("jump"):
		apply_central_impulse(Vector3(0, JUMP_FORCE, 0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if input.z != 0:
		linear_velocity.z = lerpf(linear_velocity.z, speed, sign(input.z) * vertical_speed_increment*delta)
	if input.x != 0:
		linear_velocity.x = lerpf(linear_velocity.x, speed, sign(input.x) * horizontal_speed_increment * delta)
