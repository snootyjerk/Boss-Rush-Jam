extends Control

var _main_scene = preload("res://main.tscn")
#


func _on_casual_button_button_up() -> void:
	GlobalState.is_hardcore = false
	get_tree().change_scene_to_packed(_main_scene)


func _on_hardcore_button_button_up() -> void:
	GlobalState.is_hardcore = true
	get_tree().change_scene_to_packed(_main_scene)


# REMOVE FOR FINAL BUILD!!!!!!
func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_1):
		Test.level = 1
		print("And a 1!")
		get_tree().change_scene_to_packed(_main_scene)
	if Input.is_key_pressed(KEY_2):
		Test.level = 2
		get_tree().change_scene_to_packed(_main_scene)
	if Input.is_key_pressed(KEY_3):
		Test.level = 3
		get_tree().change_scene_to_packed(_main_scene)
