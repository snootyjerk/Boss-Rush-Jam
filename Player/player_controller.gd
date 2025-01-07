extends CharacterBody2D

const TERMINAL_VELOCITY: int = 1500

@export var _max_run_speed = 100
@export var _jump_speed = 300
@export var _acceleration = 450
@export var _air_acceleration = 60
@export var _air_friction = 2500
@export var _friction = 2500
@export var _gravity = 500

@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _animation_player: AnimationPlayer = $AnimatedSprite2D/AnimationPlayer
@onready var _jump_buffer_cast: RayCast2D = $JumpBufferCast

var _has_jumped = true
var _is_jump_buffered = false
var _was_on_floor = false

var _input: Vector2



func _process(delta: float) -> void:
	_update_input()
	_apply_gravity(delta)
	
	if _input.x == 0:
		_apply_friction(delta)
		_animation_player.play("idle")
	else:
		_apply_acceleration(delta, _input)
		_flip_horizontal(_input.x > 0)
		_animation_player.play("run")
		
	if is_on_floor():
		_has_jumped = false
		if Input.is_action_just_pressed("jump") or _is_jump_buffered:
			_jump()
	else:
		#_animation_player.play("jump")
		
		# Variable jump height
		var jump_release_speed = _jump_speed / 4.0
		if Input.is_action_just_released("jump") and velocity.y < -jump_release_speed:
			velocity.y = -jump_release_speed
		
		# Jump buffer
		if _jump_buffer_cast.is_colliding():
			if Input.is_action_just_pressed("jump"):
				_is_jump_buffered = true
	# end not is_on_floor()
	
	_was_on_floor = is_on_floor()
	move_and_slide()



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
	
	
func _update_input():
	_input.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	_input.y = Input.get_action_strength("down") - Input.get_action_strength("up")
