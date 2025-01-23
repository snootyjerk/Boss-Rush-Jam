extends Node2D
class_name Boss

signal death

@export var boss_name: String
@export var boss_health: int = 1
@export var _boss_death_scene: PackedScene


func _ready() -> void:
	Main.node.boss_defeated.connect(_on_level_boss_defeated)


func _on_level_boss_defeated() -> void:
	var boss_death = _boss_death_scene.instantiate()
	get_parent().add_child(boss_death)
	boss_death.global_position = global_position
	_boss_defeated_hook()
	queue_free()


func _boss_defeated_hook(): # override in child
	pass
