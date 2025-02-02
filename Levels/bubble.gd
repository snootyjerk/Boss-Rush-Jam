extends AnimatableBody2D

var velocity = Vector2(0,-.5)
@export var _amplitude = .5
@export var _frequency = 5
@export var _max_time = 6

@onready var _sprite: AnimatedSprite2D = $Sprite2D

var _timer = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#_sprite.pause()
	#_sprite.frame = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_timer += delta
	
	velocity.x = sin(0.5*_timer*_frequency) * _amplitude
	global_position += velocity
	if _timer >= _max_time:
		take_damage()

func take_damage():
	#Play popping animation
	_sprite.play("pop")


func _on_sprite_2d_animation_finished() -> void:
	queue_free()
