extends StaticBody2D

@export var _speed: float = 300.0

var direction_degrees: float:
	get:
		return direction_degrees
	set(deg):
		direction_degrees = deg_to_rad(deg)

func _ready() -> void:
	Main.node.boss_defeated.connect(_on_boss_defeated)
	
	
func _on_boss_defeated():
	queue_free()
	

func _physics_process(delta: float):
	global_position.x += cos(direction_degrees) * _speed * delta
	global_position.y += -sin(direction_degrees) * _speed * delta


func _on_timer_timeout() -> void:
	queue_free()
