extends CharacterBody2D


@export var _move_speed: float = 50.0
@export var _enemy_death_scene: PackedScene

var _added_velocity: Vector2 = Vector2(0,0)

#var _is_being_sucked_up: bool = false


@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _process(delta: float) -> void:
	#if not _is_being_sucked_up:
	velocity = global_position.direction_to(Main.node.player_position) * _move_speed + _added_velocity
	move_and_slide()
	_added_velocity = Vector2(0,0)


func take_damage():
	var death_scene = _enemy_death_scene.instantiate()
	Main.node.current_level.add_child(death_scene)
	death_scene.global_position = global_position
	queue_free()

func _add_velocity(added_velocity: Vector2):
	_added_velocity = added_velocity
	#_is_being_sucked_up = true
