extends Node2D

@onready var cursor: TextureRect = $Cursor
@onready var cursor_targets: Node = $CursorTargets


var _cursor_target_index: int = 0

func _ready() -> void:
	var first_target: Control = cursor_targets.get_child(0)
	cursor.global_position = first_target.global_position


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("up"):
		_cursor_target_index = max(0, _cursor_target_index - 1)
	elif Input.is_action_just_pressed("down"):
		_cursor_target_index = min(_cursor_target_index + 1, cursor_targets.get_child_count() - 1)
	var new_target: Control = cursor_targets.get_child(_cursor_target_index)
	cursor.global_position = new_target.global_position
	
	if Input.is_action_just_pressed("jump"):
		match _cursor_target_index:
			0:
				Main.node.retry()
			1:
				Main.node.quit()
