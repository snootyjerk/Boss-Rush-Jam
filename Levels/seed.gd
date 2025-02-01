extends Node2D

var _credits_scene = preload("res://credits.tscn")


func _ready() -> void:
	$Sprite2D/CPUParticles2D.emitting = true


func _on_area_2d_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_packed(_credits_scene)
