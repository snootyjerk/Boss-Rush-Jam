extends Node2D

@export var _enemy_scene: PackedScene
var _enemy_count = 0
var _max_enemy_count = 3

func spawn():
	if _enemy_count < _max_enemy_count:
		var enemy = _enemy_scene.instantiate()
		enemy.killed.connect(on_enemy_killed) 
		enemy.global_position = global_position
		Main.node.current_level.add_child(enemy)
		_enemy_count +=1

func on_enemy_killed():
	_enemy_count -=1
