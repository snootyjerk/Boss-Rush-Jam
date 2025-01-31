extends Node2D
class_name Boss

signal death

@export var boss_name: String
@export var boss_health: int = 1
@export var _boss_animation_player: AnimationPlayer
@export var _boss_death_spawn_node: Node2D
@export var _boss_death_scene: PackedScene


func _ready() -> void:
	Main.node.boss_defeated.connect(_on_level_boss_defeated)


func _on_level_boss_defeated() -> void:
	if _boss_death_scene:
		var boss_death = _boss_death_scene.instantiate()
		get_parent().add_child(boss_death)
		if _boss_death_spawn_node:
			boss_death.global_position = _boss_death_spawn_node.global_position
		else:
			boss_death.global_position = global_position
	_boss_defeated_hook()
	queue_free()


func _on_damage_taken():
	if _boss_animation_player:
		_boss_animation_player.play("flash")


func _boss_defeated_hook(): # override in child
	pass
