extends Area2D

@export var _power = 15
@export var _rotation_speed = 1
var _active = true

var _target_list = Array()
var _player_quadrant = Vector2(1,1)
var _suck_timer = 5
var _rotation_direction

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_enabled(true)
	_player_quadrant = _get_player_quadrant()
	print(_player_quadrant)
	match _player_quadrant:
		Vector2(1,1):
				rotation = 0
		Vector2(1,-1):
				rotation = -90
		Vector2(-1,-1):
				rotation = 90
		Vector2(-1,1):
				rotation = 0
	_rotation_direction = -_player_quadrant.x



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	_player_quadrant = _get_player_quadrant()
	print(_player_quadrant)
	rotation += _rotation_speed * delta * _rotation_direction
	for target in _target_list:
		if target.has_method("_add_velocity"):
			target._add_velocity(target.global_position.direction_to(global_position) * _power)
	#_suck_timer -= 1*delta
	if _suck_timer <= 0:
		queue_free()
	
func _set_enabled(enabled: bool):
	_active = enabled
	visible = enabled
	#set_collision_mask_value(Constants.Layers.Player, enabled)
	#set_collision_mask_value(Constants.Layers.Enemy, enabled)
	
func _reset():
	rotation = 0
	_set_enabled(false)
	_target_list.clear()
	

func _on_body_entered(body: Node2D) -> void:
	_target_list.append(body)
	#body._add_velocity(body.global_position.direction_to(global_position) * _power)

func _on_body_exited(body: Node2D) -> void:
	_target_list.erase(body)
	
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
