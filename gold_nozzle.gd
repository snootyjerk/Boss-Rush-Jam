extends StaticBody2D

var _seed = preload("res://Levels/seed.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
		
func _on_animated_sprite_2d_animation_finished() -> void:
	var new_seed = _seed.instantiate()
	Main.node.current_level.add_child(new_seed)
	new_seed.global_position = Vector2(global_position.x,global_position.y+15)

func _on_washer_level_boss_defeated() -> void:
	visible = true
	$AnimatedSprite2D.play()
