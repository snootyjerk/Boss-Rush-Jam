extends CharacterBody2D


@export var _move_speed: float = 200.0
@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D

var direction: int = 1


func _physics_process(delta: float) -> void:
	velocity.x = direction * _move_speed
	move_and_slide()


func _on_lifespan_timer_timeout() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(_sprite, "self_modulate:a", 0.0, 1.5)
	tween.finished.connect(func():
		queue_free()
	)
