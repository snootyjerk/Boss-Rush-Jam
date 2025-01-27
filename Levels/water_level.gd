extends Area2D

var _acceleration = .1
var _high_point = 320
var _low_point = 400
var _current_level = 320
var _max_velocity = 10
var _velocity = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#global_position.y = _current_level
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_passive_movement(delta)
	
	
func _passive_movement(delta): # Slightly moves water up and down
	_velocity += _acceleration
	if _velocity >= _max_velocity or _velocity <= -_max_velocity:
		_acceleration = -_acceleration
	position.y += _velocity*delta
