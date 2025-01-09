extends Node2D
class_name Level

const LEVEL_DIR: String = "res://Levels/level_"
@export var _next_level_name: String

func get_next_level_path() -> String:
	return LEVEL_DIR + _next_level_name + ".tscn"

var _is_boss_defeated: bool = false
var is_boss_defeated: bool:
	get:
		return _is_boss_defeated


# make invisible for level transition
func _exit_tree():
	visible = false
