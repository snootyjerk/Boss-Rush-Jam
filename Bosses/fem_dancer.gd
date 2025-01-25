extends CharacterBody2D


@export var _amplitude = 1
@export var _frequency = 5
@export var _max_time = 5


var _timer = 0
enum _states {ACTIVE,WAITING,STUN,ATTACK,RECOVER}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	velocity.y = sin(_timer*_frequency) * _amplitude
	global_position += velocity
	_timer+= 1*delta
