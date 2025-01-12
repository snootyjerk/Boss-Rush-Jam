extends Area2D

@export var _power = 500
@export var _rotation_speed = .01
var _active = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_enabled(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation -= _rotation_speed
	
	
func _set_enabled(enabled: bool):
	_active = enabled
	visible = enabled
	#set_collision_mask_value(Constants.Layers.Player, enabled)
	#set_collision_mask_value(Constants.Layers.Enemy, enabled)
	
func _reset():
	rotation = 0
	_set_enabled(false)
	

func _on_body_entered(body: Node2D) -> void:
	print("hit")
	body._add_velocity(body.global_position.direction_to(global_position) * _power)
