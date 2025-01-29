extends Control

@export var _main_scene: PackedScene


func _on_button_button_up() -> void:
	get_tree().change_scene_to_packed(_main_scene)
