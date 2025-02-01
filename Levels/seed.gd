extends Node2D




func _ready() -> void:
	$Sprite2D/CPUParticles2D.emitting = true


func _on_area_2d_body_entered(body: Node2D) -> void:
	Main.node.game_completed()
