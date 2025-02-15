extends CharacterBody3D

@export_group("Camera")
@export_range(0.0, 1.0) var mouse_sensitivty := .25
@export var tilt_upper_limit := PI / 3.0
@export var tilt_lower_limit := -PI / 6.0

@export_group("Movement")
@export var move_speed := 8
@export var acceleration := 20
@export var rotation_speed := 16
@export var jump_impluse := 15

var _gravity = -30

var _camera_input_direction := Vector2.ZERO
var _last_movement_direction := Vector3.BACK

@onready var _camera: Camera3D = %Camera3D
@onready var _camera_pivot: Node3D = %CameraPivot
@onready var cat_1: MainCat = $cat1

var jump_held = 0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event.is_action_pressed("left_click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	var is_camera_motion := (event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED)
	if is_camera_motion:
		_camera_input_direction = event.screen_relative * mouse_sensitivty

func _physics_process(delta: float) -> void:
	#print(clamp(_camera_pivot.rotation.x, tilt_lower_limit, tilt_upper_limit))
	_camera_pivot.rotation.x += _camera_input_direction.y * delta
	_camera_pivot.rotation.x = clamp(_camera_pivot.rotation.x, tilt_lower_limit, tilt_upper_limit)
	_camera_pivot.rotation.y -= _camera_input_direction.x * delta
	
	_camera_input_direction = Vector2.ZERO
	
	var raw_input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var forward := _camera.global_basis.z
	var right := _camera.global_basis.x
	
	var move_direction = forward * raw_input.y + right * raw_input.x
	move_direction.y = 0
	move_direction = move_direction.normalized()
	
	var y_velocity = velocity.y
	velocity.y = 0
	velocity = velocity.move_toward(move_direction * move_speed, acceleration * delta)
	velocity.y = y_velocity + _gravity * delta
	
	#if Input.is_action_just_pressed("jump") and is_on_floor():
		#velocity.y += jump_impluse 
	
	if Input.is_action_pressed("jump") and is_on_floor():
		jump_held += delta
	elif Input.is_action_just_released("jump") and is_on_floor():
		if jump_held < 1:
			velocity.y += jump_impluse
		else:
			velocity.y += jump_impluse * clamp(jump_held, 1, 3)
			jump_held = 0
	
	move_and_slide()
	
	if move_direction.length() > 0.2:
		_last_movement_direction = move_direction
		cat_1.walk()
	else:
		cat_1.idle()
		
	var target_angle = Vector3.BACK.signed_angle_to(_last_movement_direction, Vector3.UP)
	cat_1.rotation.y = lerp_angle(cat_1.rotation.y, target_angle, rotation_speed * delta)
	
