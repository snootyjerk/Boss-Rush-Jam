extends CharacterBody2D

@export var sprite: AnimatedSprite2D
@export var animation_player: AnimationPlayer
@export var dance_anim_name: String = "dance"
@export var _player_detection_distance: float = 150.0
@export var _amplitude = 100
@export var _frequency = 5
@export var _max_hp = 3
@export var _move_speed = 150.0
@export var _dash_max_speed: float = 200.0
@export var _dash_accel: float = 300.0
@export var _dash_decel: float = 300.0

var _hp = _max_hp


var _timer = 0
enum _states {IDLE,DANCING,STUN,ATTACK,RECOVER,RESET}
var _current_state = _states.DANCING
var _prev_state = _states.DANCING

var _is_dashing: bool = false

#Return to these points
var _right_reset_point: Vector2
var _left_reset_point: Vector2
var _target_point: Vector2
var _reset_speed = 100

signal stunned
signal reset_complete

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	material.set("shader_parameter/flash_value", 0)
	Main.node.boss_phase_changed.connect(_on_boss_phase_changed)
	Main.node.man_dancer = self # used to add exception for note collisions
	sprite.pause()
	velocity.x = _move_speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	sprite.flip_h = false if sign(velocity.x) == -1 else true
	_timer += delta
	match _current_state:
		
		#_states.IDLE:
			#velocity.y = sin(_timer*_frequency) * _amplitude
			#global_position += velocity
			#_timer+= 1*delta
			
		_states.DANCING:
			if animation_player.current_animation != dance_anim_name:
				animation_player.play(dance_anim_name)
			
			velocity.y = sin(_timer * _frequency) * _amplitude
			var collision = move_and_collide(velocity * delta)
			if collision:
				velocity = velocity.bounce(collision.get_normal())
				
			#if global_position.distance_to(Main.node.player_position) < _player_detection_distance:
				#velocity = Vector2.ZERO
				#_update_state(_states.ATTACK)
			
		_states.STUN:
			velocity.x = 0.0
			velocity.y = sin(_timer * _frequency) * (_amplitude / 4)
			move_and_slide()
		#
		#_states.ATTACK:
			#if not animation_player.current_animation == "attack":
				#animation_player.play("attack")
			#if _is_dashing:
				#velocity.x = move_toward(velocity.x, _dash_max_speed, _dash_accel * delta)
			#else:
				#velocity.x = move_toward(velocity.x, _dash_max_speed, _dash_decel * delta)
			#move_and_slide()
			#
		#_states.RECOVER:
			#pass
		#
		#_states.RESET:
			##velocity = global_position.direction_to(_target_point) * _reset_speed
			##global_position = _target_point
			#if global_position == _target_point:
				#print("made it")
				#velocity = Vector2(0,0)
				#_update_state(_states.IDLE)
				#reset_complete.emit()
			
			
func _on_boss_phase_changed(phase: int):
	match phase:
		2:
			animation_player.speed_scale = 1.1875
		3:
			animation_player.speed_scale = 1.33
		4:
			animation_player.speed_scale = 1.5


func take_damage():
	_hp -= 1
	if _hp <= 0:
		set_collision_layer_value(Constants.Layers.player_hurt, false)
		set_collision_layer_value(Constants.Layers.enemy, false)
		stunned.emit()
		$StunParticles.visible = true
		var rot_dir = -1 if sprite.flip_h else 1
		sprite.rotation_degrees = 90 * rot_dir
		animation_player.pause()
		_update_state(_states.STUN)
	else:
		$FlashAnimation.play("flash")


func _reset_position(side: String):
	_update_state(_states.RESET)
	if side == "right":
		_target_point = _right_reset_point
	else:
		_target_point = _left_reset_point
	
		
func _revive():
	_hp = _max_hp
	sprite.rotation_degrees = 0
	velocity.x = _move_speed
	$StunParticles.visible = false
	set_collision_layer_value(Constants.Layers.player_hurt, true)
	set_collision_layer_value(Constants.Layers.enemy, true)
	animation_player.play(dance_anim_name)
	_update_state(_states.DANCING)


func _update_state(new_state):
	_prev_state = _current_state
	_current_state = new_state
	
	
#func _attack_accelerate():
	#_is_dashing = true
	#
	#
#func _attack_decelerate():
	#_is_dashing = false
	#
	#
#func _attack_finish():
	#_update_state(_states.RECOVER)
	#$RecoverTimer.start()
#
#
#func _on_recover_timer_timeout() -> void:
	#_update_state(_states.DANCING)
	#velocity.x = _move_speed * [-1, 1].pick_random()
