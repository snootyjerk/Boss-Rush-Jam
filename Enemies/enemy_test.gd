extends CharacterBody2D


@export var _move_speed: float = 50.0


func _process(delta: float) -> void:
	velocity = global_position.direction_to(Main.node.player_position) * _move_speed
	move_and_slide()
