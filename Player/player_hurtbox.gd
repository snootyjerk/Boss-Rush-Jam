extends Area2D


@export var _sprite_flash_frequency: float
@export var _sprite_flash_count: int


@onready var _sprite = $"../AnimatedSprite2D"


var _has_iframes: bool = false
var _hitbox_collision_count: int


func _on_body_entered(body):
	_hitbox_collision_count += 1
	if not _has_iframes:
		_take_damage()
		
		
func _on_body_exited(body):
	_hitbox_collision_count -= 1


func _take_damage():
	Main.node.damage_player()
	_has_iframes = true
	
	for i in range(_sprite_flash_count):
		_sprite.visible = false
		await get_tree().create_timer(_sprite_flash_frequency).timeout
		_sprite.visible = true
		await get_tree().create_timer(_sprite_flash_frequency).timeout
		
	_has_iframes = false
	if _hitbox_collision_count > 0:
		_take_damage()
