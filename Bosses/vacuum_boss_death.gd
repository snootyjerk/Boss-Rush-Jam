extends CharacterBody2D

@export var _gravity: float = 1201.0

@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	_sprite.speed_scale = 0.0


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += _gravity * delta
	else:
		_sprite.speed_scale = 1.0
		
	move_and_slide()
