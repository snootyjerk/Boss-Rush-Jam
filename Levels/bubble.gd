extends AnimatableBody2D

var velocity = Vector2(0,-.1)
@export var _amplitude = .5
@export var _frequency = 5
@export var _max_time = 10

var _timer = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_timer+= .5*delta
	
	velocity.x = sin(_timer*_frequency) * _amplitude
	global_position += velocity
	if _timer >= _max_time:
		queue_free()
