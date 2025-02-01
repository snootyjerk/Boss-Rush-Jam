extends Node2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	Main.node.game_completed()
