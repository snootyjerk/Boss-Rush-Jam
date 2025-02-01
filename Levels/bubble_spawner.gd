extends Node2D
var _bubble_scene = preload("res://Levels/Features/bubble.tscn")
@export var _max_timer =  3	
@export var _timer = 2



func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	_timer -= 1*delta
	if _timer <= 0:
		_spawn_bubble()
		_timer = _max_timer

func _spawn_bubble():
	var new_bubble = _bubble_scene.instantiate()
	add_child(new_bubble)
	new_bubble.global_position = global_position
