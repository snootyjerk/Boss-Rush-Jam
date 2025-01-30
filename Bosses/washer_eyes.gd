extends RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _drop():
	set_collision_layer_value(Constants.Layers.enemy, true)
	global_position.y -= 20
	
func _repair():
	set_collision_layer_value(Constants.Layers.enemy, false)
	global_position.y +=20

func take_damage():
	Main.node.damage_boss()
