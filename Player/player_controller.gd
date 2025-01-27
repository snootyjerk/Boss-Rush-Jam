extends CharacterBody2D
class_name PlayerController

const TERMINAL_VELOCITY: int = 1500

var _fan_projectile_scene = preload("res://Player/fan_projectile.tscn")

@export var _max_run_speed = 100
@export var _jump_speed = 300
@export var _acceleration = 450
@export var _air_acceleration = 60
@export var _air_friction = 2500
@export var _friction = 2500
@export var _gravity = 500

@export var _max_energy = 100
@export var _flight_acceleration = 100

@export var knockback_speed: float = 200


@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _animation_player: AnimationPlayer = $AnimatedSprite2D/AnimationPlayer
@onready var _jump_buffer_cast: RayCast2D = $JumpBufferCast
@onready var attack_hitbox: Area2D = $AttackHitbox
@onready var _audio_stream_player: AudioStreamPlayer = $AnimatedSprite2D/FootstepAudioPlayer
@onready var _jump_audio_player: AudioStreamPlayer = $AnimatedSprite2D/JumpAudioPlayer
@onready var fly_audio_player: AudioStreamPlayer = $AnimatedSprite2D/FlyAudioPlayer
@onready var fan_launch_point: Node2D = $AnimatedSprite2D/FanLaunchPoint
@onready var fan_launch_cast: RayCast2D = $AnimatedSprite2D/FanLaunchCast

var _fly_audio_original_db: float

var _has_jumped = true
var _is_jump_buffered = false
var _was_on_floor = false
var _has_fan: bool = true
var _added_velocity: Vector2 = Vector2(0,0)
var _is_flying = false:
	set(flying):
		_is_flying = flying
		attack_hitbox.set_enabled(flying)
var _current_energy = _max_energy:
	set(energy):
		_current_energy = energy
		Main.node.player_energy = _current_energy

enum States { MOBILE, THROW_FAN }
var _state: States = States.MOBILE


var _input: Vector2


func _ready() -> void:
	_fly_audio_original_db = fly_audio_player.volume_db
	$AnimatedSprite2D/ArmsPivot/ArmsSprite.visible = false


func _process(delta: float) -> void:
	match _state:
		States.MOBILE:
			_state_mobile(delta)
		States.THROW_FAN:
			_state_throw_fan(delta)


func _state_mobile(delta: float):
	_update_input()
	_apply_gravity(delta)
	
	if _input.x == 0:
		_apply_friction(delta)
	else:
		_apply_acceleration(delta, _input)
		_flip_horizontal(_input.x < 0)
		
	if is_on_floor():
		_has_jumped = false
		_is_flying = false
		
		#Refills flight energy when grounded if it's below max
		if _current_energy < _max_energy:   
			_current_energy += 1
		elif _current_energy > _max_energy:
			_current_energy = _max_energy

		if Input.is_action_just_pressed("jump") or _is_jump_buffered:
			_jump()
	elif _is_flying == false:
		# Variable jump height
		var jump_release_speed = _jump_speed / 4.0
		if Input.is_action_just_released("jump") and velocity.y < -jump_release_speed:
			velocity.y = -jump_release_speed
		
		# Jump buffer
		if _jump_buffer_cast.is_colliding():
			if Input.is_action_just_pressed("jump"):
				_is_jump_buffered = true
		elif Input.is_action_just_pressed("jump") and _current_energy > 0: # Start flying if jump is pressed midair 	
			_is_flying = _has_fan
			
		# Flight audio stop
		if fly_audio_player.playing:
			var tween = get_tree().create_tween()
			tween.tween_property(fly_audio_player, "volume_db", -80.0, 0.2)
			tween.finished.connect(func():
				fly_audio_player.stop()
			)
	#Flight
	else:
		_fly()
		
	#End flight
	_was_on_floor = is_on_floor()
	velocity += _added_velocity
	move_and_slide()
	#if _added_velocity != Vector2(0,0):
			#print(_added_velocity)
	_added_velocity = Vector2(0,0)
	_animation()
	
	if Input.is_action_just_pressed("throw") and _has_fan:
		_throw_fan()
	
	Main.node.player_position = global_position
	
	
func _state_throw_fan(delta: float):
	pass


func _apply_gravity(delta):
	if not is_on_floor():
		velocity.y += _gravity * delta
		velocity.y = min(velocity.y, TERMINAL_VELOCITY)
		
		
func _apply_friction(delta):
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0, _friction * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, _air_friction * delta)
		
		
func _apply_acceleration(delta, input_vector: Vector2):
	var accel = _acceleration if is_on_floor() else _air_acceleration
	velocity.x = move_toward(velocity.x, _max_run_speed * sign(input_vector.x), accel * delta)
	
	
func _flip_horizontal(_flip: bool):
	_sprite.scale.x = -1 if _flip else 1
	
	
func _jump():
	velocity.y = -_jump_speed
	_has_jumped = true
	_is_jump_buffered = false
	_animation_player.play("jump")
	
	
func _fly():
	if _has_fan:
		velocity.y = -_flight_acceleration
		_current_energy -= 1
		if not fly_audio_player.playing:
			fly_audio_player.volume_db = _fly_audio_original_db
			fly_audio_player.play()
	if _current_energy <= 0 or Input.is_action_just_released("jump"):
		_is_flying = false
		
		
func _throw_fan():
	if _has_fan:
		if not fan_launch_cast.is_colliding():
			_animation_player.play("throw")
			velocity = Vector2.ZERO
			_is_flying = false
			_has_fan = false
			_state = States.THROW_FAN
			
			var fan_projectile = _fan_projectile_scene.instantiate()
			fan_projectile.global_position = fan_launch_point.global_position
			Main.node.current_level.add_child(fan_projectile)
			fan_projectile.throw(_sprite.scale.x)
			fan_projectile.recalled.connect(func():
				_has_fan = true
			)
	

	
	
func _on_throw_animation_finished():
	_state = States.MOBILE
		
	
func _add_velocity(added_velocity: Vector2):
	_added_velocity += added_velocity
	
	
func _update_input():
	_input.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	_input.y = Input.get_action_strength("down") - Input.get_action_strength("up")


func _on_hurtbox_damaged(contact_point: Vector2) -> void:
	var delta: Vector2 = (global_position - contact_point).normalized()
	velocity = delta * knockback_speed
	
	
	
func _animation():
	if is_on_floor():
		if _input.x == 0:
			_animation_player.play("idle")
		else:
			_animation_player.play("run")
	else:
		if _is_flying:
			_animation_player.play("air")
		#if not _has_fan:
			#_animation_player.play("air_no_fan")


func _on_foot_step():
	_audio_stream_player.pitch_scale = randf_range(0.5, 1.0)
	_audio_stream_player.play()
	
	
func _on_jump():
	_jump_audio_player.play()


func _on_water_level_body_entered(body: Node2D) -> void:
	print("in water")
	_max_run_speed = 50
	_jump_speed = 150
	_acceleration = 225
	_air_acceleration = 30
	_air_friction = 5000
	_friction = 5000
	_gravity = 250
	_flight_acceleration = 25


func _on_water_level_body_exited(body: Node2D) -> void:
	print("out of water")
	_max_run_speed = 100
	_jump_speed = 300
	_acceleration = 450
	_air_acceleration = 60
	_air_friction = 2500
	_friction = 2500
	_gravity = 500
	_flight_acceleration = 100
