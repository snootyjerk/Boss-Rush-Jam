extends Area2D

@export var _power = 15
@export var _rotation_speed = .01
var _active = true

var _target_list = Array()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_enabled(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	rotation -= _rotation_speed * delta
	for target in _target_list:
		target._add_velocity(target.global_position.direction_to(global_position) * _power * delta)
	
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
