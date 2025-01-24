extends Node2D

@export var _enemy_scene: PackedScene


func spawn():
	var enemy = _enemy_scene.instantiate()
	enemy.global_position = global_position
	Main.node.current_level.add_child(enemy)
