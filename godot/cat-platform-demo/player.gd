extends CharacterBody3D

class_name Player

@export_group("Camera")
@export_range(0.0, 1.0) var mouse_sensitivty := .25
@export var tilt_upper_limit := PI / 3.0
@export var tilt_lower_limit := -PI / 6.0

@export_group("Movement")
@export var move_speed := 8
@export var acceleration := 20
@export var rotation_speed := 16
@export var jump_impluse := 15
@export var enemy_jump_force := 10

@export_group("Damage")
@export var damage := 20
@export var jump_damage := 10

var _gravity = -30

var _camera_input_direction := Vector2.ZERO
var _last_movement_direction := Vector3.BACK

@onready var _camera: Camera3D = %Camera3D
@onready var _camera_pivot: Node3D = %CameraPivot
@onready var cat_1: MainCat = $cat
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var collision_shape_3d2: CollisionShape3D = $HitboxComponent2/CollisionShape3D
@onready var death_menu: CanvasLayer = $CameraPivot/DeathMenu
@onready var pause_menu: CanvasLayer = $CameraPivot/PauseMenu
@onready var attack_hitbox: HitboxComponent = $AttackHitbox
@onready var hitbox_component_2: HitboxComponent = $HitboxComponent2
@onready var ray_cast_3d: RayCast3D = $RayCast3D

var _on_enemy = false

var jump_held = 0
var _attacking = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and not get_tree().paused:
		print(get_tree().paused)
		pause_menu.show()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true
	elif event.is_action_pressed("left_click") and !pause_menu.visible:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	var is_camera_motion := (event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED)
	if is_camera_motion:
		_camera_input_direction = event.screen_relative * mouse_sensitivty

func _physics_process(delta: float) -> void:
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
	
	if is_on_floor() and cat_1.animation_player.current_animation == "Jump_001" and cat_1.animation_finished:
		cat_1.walk()
	
	if is_on_enemy():
		if is_on_floor():
			var enemy = hitbox_component_2.get_overlapping_areas().back()
			if enemy is HitboxComponent:
				enemy.damage(jump_damage)
				_attacking = false
			velocity.y += enemy_jump_force
		move_direction = _last_movement_direction
	
	var y_velocity = velocity.y
	velocity.y = 0
	velocity = velocity.move_toward(move_direction * move_speed, acceleration)
	velocity.y = y_velocity + _gravity * delta
	
	
	if Input.is_action_pressed("jump") and is_on_floor():
		jump_held += delta
	elif Input.is_action_just_released("jump") and is_on_floor():
		if jump_held < .6:
			velocity.y += jump_impluse
		else:
			velocity.y += jump_impluse * clamp(jump_held, 1, 1.5)
			jump_held = 0
		cat_1.jump()
	
	move_and_slide()
	
	if move_direction.length() > 0.2:
		_last_movement_direction = move_direction
		
		if not _attacking and is_on_floor():
			cat_1.walk()
	elif not _attacking and is_on_floor():
		cat_1.idle()
		
	var target_angle = Vector3.BACK.signed_angle_to(_last_movement_direction, Vector3.UP)
	cat_1.rotation.y = lerp_angle(cat_1.rotation.y, target_angle, rotation_speed * delta)
	attack_hitbox.rotation.y = cat_1.rotation.y
	collision_shape_3d.rotation.y = cat_1.rotation.y
	collision_shape_3d2.rotation.y = cat_1.rotation.y
	
	
	if Input.is_action_just_pressed("left_click") and not _attacking:
		attack()


func attack():
	cat_1.damage()
	_attacking = true
	_damage_in_range()

func _damage_in_range():
	var areas = attack_hitbox.get_overlapping_areas()

	for area in areas:
		if area is HitboxComponent:
			area.damage(damage)
	
func _on_cat_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		_attacking = false


func _on_health_component_death() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	death_menu.show()
	get_tree().paused = true
	


func _on_pause_menu_resume() -> void:
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pause_menu.hide()

func is_on_enemy():
	if ray_cast_3d.is_colliding():
		_on_enemy = true
		return true
	elif _on_enemy and !is_on_floor():
		return true
	
	_on_enemy = false
	return false

func _is_enemy(body: Node3D):
	body is EnemyDummy
