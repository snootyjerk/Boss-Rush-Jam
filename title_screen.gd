extends Control

@export var _main_scene: PackedScene


func _on_button_button_up() -> void:
	get_tree().change_scene_to_packed(_main_scene)

# REMOVE FOR FINAL BUILD!!!!!!
func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_1):
		Test.level = 1
	if Input.is_key_pressed(KEY_2):
		Test.level = 2
	if Input.is_key_pressed(KEY_3):
		Test.level = 3
	
	if Test.level > 0:
		get_tree().change_scene_to_packed(_main_scene)
