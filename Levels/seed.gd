extends Node2D

var _acceleration = -.05
var _max_velocity = 10
var _velocity = 0

var _grav_vector = Vector2(0,15)
var _drop_timer = 4

func _process(delta: float) -> void:
	if _drop_timer >0:
		global_position += _grav_vector*delta
		_drop_timer -= 1*delta
	else:
		_passive_movement(delta)
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	Main.node.game_completed()

func _passive_movement(delta): # Slightly moves water up and down
	_velocity += _acceleration
	if _velocity >= _max_velocity or _velocity <= -_max_velocity:
		_acceleration = -_acceleration
	global_position.y += _velocity*delta
