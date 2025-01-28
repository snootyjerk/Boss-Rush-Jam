extends CharacterBody2D

@export var _move_speed: float = 200.0
@export var _jump_speed: float = 150.0
@export var _dive_speed: float = 500.0
@export var _player_detection_distance: = 64.0
@export var sprite: AnimatedSprite2D
@export var animation_player: AnimationPlayer
@export var dance_anim_name: String = "dance"
@export var _max_hp = 3
var _hp = _max_hp

@onready var recover_timer: Timer = $RecoverTimer

@export var _amplitude = 100
@export var _frequency = 5
var _timer = 0
enum _states {IDLE,DANCING,STUN,ATTACK,RECOVER,RESET}
var _current_state = _states.DANCING
var _prev_state = _states.DANCING

#Return to these points
var _right_reset_point: Vector2
var _left_reset_point: Vector2
var _target_point: Vector2
var _reset_speed = 100

signal stunned
signal reset_complete


func _ready() -> void:
	Main.node.fem_dancer = self # used to add exception for note collisions
	Main.node.boss_phase_changed.connect(_on_boss_phase_changed)
	velocity.x = -_move_speed
	


func _process(delta: float) -> void:
	_timer += delta
	match _current_state:
		_states.DANCING:
			velocity.y = sin(_timer * _frequency) * _amplitude
			var collision = move_and_collide(velocity * delta)
			if collision:
				velocity = velocity.bounce(collision.get_normal())
				
			#if global_position.distance_to(Main.node.player_position) < _player_detection_distance:
				#velocity = Vector2.ZERO
				#_update_state(_states.ATTACK)
			
		_states.STUN:
			velocity = Vector2(0,0)
		
		#_states.ATTACK:
			#if not animation_player.is_playing():
				#animation_player.play("attack")
			#move_and_slide()
			
		#_states.RECOVER:
			#pass
			
			
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
		sprite.pause()
		rotation = 90
		_update_state(_states.STUN)


func _reset_position(side: String):
	_update_state(_states.RESET)
	if side == "right":
		_target_point = _right_reset_point
	else:
		_target_point = _left_reset_point
	
		
func _revive():
	_hp = _max_hp
	rotation = 0
	velocity.x = -_move_speed
	sprite.play()
	set_collision_layer_value(Constants.Layers.player_hurt, true)
	set_collision_layer_value(Constants.Layers.enemy, true)
	_update_state(_states.DANCING)


func _update_state(new_state):
	_prev_state = _current_state
	_current_state = new_state



#func _attack_jump():
	#velocity.y = -_jump_speed
	#
	#
#func _attack_dive():
	#var angle: float
	#if global_position.x < Main.node.player_position.x:
		#angle = deg_to_rad(-45.0)
	#else:
		#angle = deg_to_rad(225.0)
		#
	#velocity.x = cos(angle) * _dive_speed
	#velocity.y = -sin(angle) * _dive_speed
#
#
#func _attack_recover():
	#velocity = Vector2.ZERO
	#recover_timer.start()
	#_update_state(_states.RECOVER)
#
#
#func _on_recover_timer_timeout() -> void:
	#if _hp > 0:
		#velocity.x = [-1, 1].pick_random() * _move_speed
		#_update_state(_states.DANCING)
