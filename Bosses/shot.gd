extends Node2D

var _angle: Vector2
@export var _speed = 100
@export var _timer = 2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position += _angle * _speed*delta
	_timer -= 1*delta
	if _timer <= 0:
		queue_free()
