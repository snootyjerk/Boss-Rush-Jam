extends Node2D

var _new_nozzle = preload("res://Levels/Features/water_nozzle.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _spawn_nozzle():
	var nozzle = _new_nozzle.instantiate()
	Main.node.current_level.add_child(nozzle)
	nozzle.global_position = global_position
	nozzle.rotation = rotation
