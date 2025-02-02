extends Control

var _credits_scene = preload("res://credits.tscn")


@onready var play_time: Label = $PlayTime


func _ready() -> void:
	play_time.text = GlobalState.time_str


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_packed(_credits_scene)
