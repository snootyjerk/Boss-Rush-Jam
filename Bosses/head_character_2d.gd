extends CharacterBody2D
class_name VacuumHead


var _boss_death_head = preload("res://Bosses/vacuum_boss_death_head.tscn")
var _suction_attack = preload("res://Bosses/suction_hitbox.tscn")


@export var _idle_speed: float = 25
@export var _strike_speed: float = 250
@export var _tether_length: float = 100

@export var _idle_timer_max = 70
var _idle_timer = _idle_timer_max

@export var _pause_timer_max = 20
var _pause_timer = _pause_timer_max

@export var _recover_timer_max = 100
var _recover_timer = _recover_timer_max

@export var _suction_timer_max = 100
var _suction_timer = _suction_timer_max

@onready var _tether_point = global_position
var _target_direction = Vector2(1,0)

var _attack = null

enum _states {IDLE,PAUSE,STRIKE,RECOVER,SUCTION}
#Idle: move back and forth, waiting for player to come in range. 
#Pause: wait a short while before charging at player
#Strike: charge at player
#Recover: move towards tether point, return to idle state 
#Suction: Emit a coneshaped hit box and sweep it across the level. 
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
				_start_suction()
			if global_position.distance_to(_tether_point) > _tether_length:
				_target_direction = global_position.direction_to(_tether_point)
				#print("too far")
				#print(global_position.distance_to(_tether_point))
				#print(_tether_point)
				
		_states.PAUSE:
			_pause_timer -= 14
			velocity = Vector2(0,0)
			if _pause_timer <= 0:
				_pause_timer = _pause_timer_max
				_update_state(_states.STRIKE)
				
		_states.STRIKE:
			velocity = _target_direction * _strike_speed
			if global_position.distance_to(_tether_point) > _tether_length:
				_start_recovery(_recover_timer_max)
				
		_states.RECOVER:
			velocity = _target_direction * _idle_speed
			_recover_timer -= 1
			if _recover_timer <= 0:
				_recover_timer = _recover_timer_max
				_update_state(_states.IDLE)
		
		_states.SUCTION:
			var _attack = _suction_attack.instantiate()
			_attack.global_position = global_position
	move_and_slide()
	
	
func _get_player_in_range() -> bool:
	var _player_distance =  _tether_point.distance_to(Main.node.player_position)
	if _player_distance <= _tether_length:
		return true
	else:
		return false


func _start_recovery(time: int):
	_target_direction = global_position.direction_to(_tether_point)
	_update_state(_states.RECOVER)
	_recover_timer = time


func _update_state(new_state):
	_prev_state = _current_state
	_current_state = new_state
	if _prev_state == _states.SUCTION:
		_attack.queue_free()
		_attack = null


func _start_suction():
	_attack = _suction_attack.instantiate()
	var callable = Callable(self,"_start_recovery").bind(_recover_timer_max)
	velocity = Vector2(0,0)
	_attack.global_position = global_position
	_attack._player_quadrant = _get_player_quadrant()
	_attack._suction_complete.connect(callable)
	Main.node.current_level.add_child(_attack)
	_update_state(_states.SUCTION)


func _get_player_quadrant() -> Vector2:
	var result: Vector2
	if Main.node.player_position.x >= global_position.x:
		result = Vector2(1,0)
	else:
		result = Vector2(-1,0)
	if Main.node.player_position.y >= global_position.y:
		result += Vector2(0,1)
	else:
		result += Vector2(0,-1)
	return result


func take_damage():
	Main.node.damage_boss()
