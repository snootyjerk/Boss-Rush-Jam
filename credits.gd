extends Control


var _can_input = false


func _input(event: InputEvent) -> void:
	if _can_input:
		if Input.is_action_just_pressed("jump"):
			_next()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	_next()


func _input_delay_finished():
	_can_input = true
	

func _next():
	get_tree().change_scene_to_file("res://title_screen.tscn")
