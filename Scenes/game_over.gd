extends Node2D


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		Main.node.retry()
