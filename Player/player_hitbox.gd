extends Area2D




func _on_body_entered(body: Node2D) -> void:
	body.take_damage()


func set_enabled(enabled: bool):
	visible = enabled
	set_collision_mask_value(Constants.Layers.enemy, enabled)
