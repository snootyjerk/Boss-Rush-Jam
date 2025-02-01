extends Area2D

signal damaged(contact_point: Vector2)

@export var _sprite_flash_frequency: float
@export var _sprite_flash_count: int
@export var _sfx: AudioStreamPlayer


@onready var _sprite = $"../AnimatedSprite2D"
@onready var flicker_animation_player: AnimationPlayer = $FlickerAnimationPlayer


var _has_iframes: bool = false
var _hitbox_collision_count: int
var _hitbox_contact_point: Vector2


func _ready():
	flicker_animation_player.animation_finished.connect(_on_flicker_finished)


func _on_body_entered(body):
	_hitbox_collision_count += 1
	if not _has_iframes:
		_take_damage()
		damaged.emit(body.global_position)
		
		
func _on_body_exited(body):
	_hitbox_collision_count -= 1


func _take_damage():
	Main.node.damage_player()
	_has_iframes = true
	flicker_animation_player.play("flicker")
	if _sfx and Main.node.player_health > 0:
		_sfx.play()


func _on_flicker_finished(anim_name: StringName):
	_has_iframes = false
	if _hitbox_collision_count > 0:
		_take_damage()
