extends Node2D


@export var _direction_1_or_neg1: int = 1
@export var _tornado_scene: PackedScene

func _ready():
	Main.node.boss_phase_changed.connect(_on_boss_phase_changed)
	Main.node.boss_defeated.connect(_on_boss_defeated)
	$Timer.timeout.connect(_on_timeout)
	
	
func _on_timeout():
	var tornado = _tornado_scene.instantiate()
	tornado.global_position = global_position
	tornado.direction = _direction_1_or_neg1
	Main.node.current_level.add_child(tornado)


func _on_boss_phase_changed(new_phase: int):
	if new_phase == 2:
		_on_timeout()
		if _direction_1_or_neg1 == -1:
			await get_tree().create_timer($Timer.wait_time / 2.0).timeout
		$Timer.start()


func _on_boss_defeated():
	$Timer.stop()
