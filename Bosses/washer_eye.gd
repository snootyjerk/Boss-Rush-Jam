extends CharacterBody2D
class_name WasherEye

signal damaged # both eyes flash at once

@onready var eye_pupil: AnimatedSprite2D = $EyeWhites/EyePupil

var _is_dropped: bool = false
var _origin: Vector2
var _global_origin: Vector2


func _ready() -> void:
	material.set("shader_parameter/flash_value", 0)
	_origin = eye_pupil.position
	_global_origin = eye_pupil.global_position
	
	set_collision_layer_value(Constants.Layers.enemy, false)
	set_collision_layer_value(Constants.Layers.player_hurt, false)


func _process(delta: float) -> void:
	_global_origin = eye_pupil.global_position
	var to_vec = _global_origin.direction_to(Main.node.player_position)
	eye_pupil.position.x = _origin.x + (to_vec.x * 8.0)
	eye_pupil.position.y = _origin.y + (to_vec.y * 8.0)
	
	
func drop():
	set_collision_layer_value(Constants.Layers.enemy, true)
	set_collision_layer_value(Constants.Layers.player_hurt, true)
	eye_pupil.play()
	
	
func repair():
	set_collision_layer_value(Constants.Layers.enemy, false)
	set_collision_layer_value(Constants.Layers.player_hurt, false)
	eye_pupil.play_backwards()


func take_damage():
	Main.node.damage_boss()
	damaged.emit()
	
	
func flash_animation():
	$FlashAnimation.play("flash")
