extends CharacterBody2D
class_name PlayerController

const TERMINAL_VELOCITY: int = 1500

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
@onready var audio_stream_player: AudioStreamPlayer = $AnimatedSprite2D/AudioStreamPlayer

var _has_jumped = true
var _is_jump_buffered = false
var _was_on_floor = false
var _is_flying = false:
	set(flying):
		_is_flying = flying
		attack_hitbox.set_enabled(flying)
var _current_energy = _max_energy:
	set(energy):
		_current_energy = energy
		Main.node.player_energy = _current_energy


var _input: Vector2



func _process(delta: float) -> void:
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
			_is_flying = true
	#Flight
	else:
		_fly()
		
	#End flight
	_was_on_floor = is_on_floor()
	move_and_slide()
	_animation()
	Main.node.player_position = global_position



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
	_sprite.flip_h = _flip
	
	
func _jump():
	velocity.y = -_jump_speed
	_has_jumped = true
	_is_jump_buffered = false
	
func _fly():
	velocity.y = -_flight_acceleration
	_current_energy -= 1
	if _current_energy <= 0 or Input.is_action_just_released("jump"):
		_is_flying = false
	
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
		_animation_player.play("air")


func _on_foot_step():
	audio_stream_player.pitch_scale = randf_range(0.5, 1.0)
	audio_stream_player.play()
