extends CharacterBody2D

@export var _amplitude = 1
@export var _frequency = 5
@export var _max_hp = 3
var _hp = _max_hp

var _timer = 0
enum _states {IDLE,DANCING,STUN,ATTACK,RECOVER,RESET}
var _current_state = _states.IDLE
var _prev_state = _states.IDLE

#Return to these points
var _right_reset_point = Vector2(632,144)
var _left_reset_point = Vector2(8,144)
var _target_point = _right_reset_point
var _reset_speed = 100

signal stunned
signal reset_complete

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match _current_state:
		
		_states.IDLE:
			velocity.y = sin(_timer*_frequency) * _amplitude
			global_position += velocity
			_timer+= 1*delta
			
		_states.DANCING:
			pass
			
		_states.STUN:
			velocity = Vector2(0,0)
		
		_states.ATTACK:
			pass
		
		_states.RECOVER:
			pass
		
		_states.RESET:
			velocity = global_position.direction_to(_target_point) * _reset_speed
			if global_position == _target_point:
				velocity = Vector2(0,0)
				_update_state(_states.IDLE)
				reset_complete.emit()
			
func take_damage():
	_hp -= 1
	if _hp <= 0:
		stunned.emit()
		_update_state(_states.STUN)

func _reset_position(side: String):
	_update_state(_states.RESET)
	if side == "right":
		_target_point = _right_reset_point
		
func _revive():
	_hp = _max_hp

func _update_state(new_state):
	_prev_state = _current_state
	_current_state = new_state
