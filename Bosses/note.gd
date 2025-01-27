extends StaticBody2D

var velocity = Vector2(-1,0)
@export var _amplitude = 1
@export var _frequency = 5
@export var _max_time = 10

var _timer = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_collision_exception_with(Main.node.fem_dancer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_timer+= 1*delta
	
	velocity.y = sin(_timer*_frequency) * _amplitude
	global_position += velocity
	if _timer >= _max_time:
		queue_free()
