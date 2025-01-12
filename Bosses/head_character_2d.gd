extends CharacterBody2D


@export var _idle_speed: float = 25
@export var _strike_speed: float = 250
@export var _tether_length: float = 100

@export var _idle_timer_max = 70
var _idle_timer = _idle_timer_max

@export var _pause_timer_max = 20
var _pause_timer = _pause_timer_max

@export var _recover_timer_max = 100
var _recover_timer = _recover_timer_max

@onready var _tether_point = global_position
var _target_direction = Vector2(1,0)
enum _states {IDLE,PAUSE,STRIKE,RECOVER,VACUUM}
#Idle: move back and forth, waiting for player to come in range. 
#Pause: wait a short while before charging at player
#Strike: charge at player
#Recover: move towards tether point, return to idle state 
#Vacuum: Emit a coneshaped hit box and sweep it across the level. 
	#Objects caught in the hitbox will be pulled towards the boss.

var _current_state = _states.IDLE
var _prev_state = _states.IDLE

func _physics_process(delta: float) -> void:
	match _current_state:
		
		_states.IDLE:
			velocity = _target_direction * _idle_speed
			_idle_timer -= 1
			if _get_player_in_range():
				_idle_timer = _idle_timer_max
				_update_state(_states.PAUSE)
				_target_direction = global_position.direction_to(Main.node.player_position)
			elif _idle_timer <= 0:
				_idle_timer = _idle_timer_max
				_target_direction = global_position.direction_to(_tether_point)
			if global_position.distance_to(_tether_point) > _tether_length:
				_target_direction = global_position.direction_to(_tether_point)
				print("too far")
				print(global_position.distance_to(_tether_point))
				print(_tether_point)
				
		_states.PAUSE:
			_pause_timer -= 1
			velocity = Vector2(0,0)
			if _pause_timer <= 0:
				_pause_timer = _pause_timer_max
				_update_state(_states.STRIKE)
				
		_states.STRIKE:
			velocity = _target_direction * _strike_speed
			if global_position.distance_to(_tether_point) > _tether_length:
				_target_direction = global_position.direction_to(_tether_point)
				_update_state(_states.RECOVER)
				
		_states.RECOVER:
			velocity = _target_direction * _idle_speed
			_recover_timer -= 1
			if _recover_timer <= 0:
				_recover_timer = _recover_timer_max
				_update_state(_states.IDLE)
			
	move_and_slide()
	
func _get_player_in_range() -> bool:
	var _player_distance =  _tether_point.distance_to(Main.node.player_position)
	if _player_distance <= _tether_length:
		return true
	else:
		return false

func _update_state(new_state):
	_prev_state = _current_state
	_current_state = new_state
	print(_current_state)
