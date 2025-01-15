extends RigidBody2D

@export var _bounce_on_hit_impulse: float = 100.0

func _ready() -> void:
	self.apply_impulse(Vector2.UP * _bounce_on_hit_impulse)
	#add_constant_force(Vector2.UP * _bounce_on_hit_force)

#func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	#queue_free()
