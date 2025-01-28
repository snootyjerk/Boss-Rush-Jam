extends Area2D

var _acceleration = .1
@export var _high_point = 100
@export var _low_point = 340
@export var _x_current = 10
var _current_level = 320
var _target_level = _current_level
var _max_velocity = 10
var _velocity = 0
var _adjusting = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#global_position.y = _current_level
	_set_level(_high_point)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _adjusting == false:
		_passive_movement(delta)
	else:
		_adjust_level(delta)
	
func _passive_movement(delta): # Slightly moves water up and down
	_velocity += _acceleration
	if _velocity >= _max_velocity or _velocity <= -_max_velocity:
		_acceleration = -_acceleration
	global_position.y += _velocity*delta

func _adjust_level(delta):
	if (global_position.y < _target_level):
		global_position.y +=  _max_velocity*delta
		if global_position.y >= _target_level:
			_current_level = _target_level
			_adjusting = false
	elif (global_position.y > _target_level):
		global_position.y -= _max_velocity*delta
		if global_position.y <= _target_level:
			_current_level = _target_level
			_adjusting = false
	else:
		_current_level = _target_level
		_adjusting = false

func _set_level(height):
	if height != _current_level:
		_adjusting = true
		_target_level = height
		
