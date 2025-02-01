extends Area2D

@export var _high_point = 50
@export var _mid_point = 150
@export var _low_point = 240
@export var _lower_point = 300
@export var _lowest_point = 340
@export var _x_current = 10

#Variables for 'passive' water movement when not being raised/ lowered
var _acceleration = .1
var _max_velocity = 10
var _velocity = 0

#Variables for raising/ lowering water level
var _current_level = 320
var _target_level = _current_level
var _adjusting_velocity = 20
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
		global_position.y +=  _adjusting_velocity*delta
		if global_position.y >= _target_level:
			_current_level = _target_level
			_adjusting = false
	elif (global_position.y > _target_level):
		global_position.y -= _adjusting_velocity*delta
		if global_position.y <= _target_level:
			_current_level = _target_level
			_adjusting = false
	else:
		_current_level = _target_level
		_adjusting = false

func _set_level(nozz_count):
	var height
	match nozz_count:
		0:
			height = _lowest_point
		1:
			height = _lower_point
		2:
			height = _low_point
		3:
			height = _mid_point
		4:
			height = _mid_point
		5:
			height = _high_point
		_:
			height = _high_point
			
	if height != _current_level:
		_adjusting = true
		_target_level = height

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("_submerge"):
		body._submerge()

func _on_body_exited(body: Node2D) -> void:
	if body.has_method("_emerge"):
		body._emerge()
