extends PathFollow2D

var _speed = .1
var _offset = 20

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	v_offset = randi_range(-_offset,_offset)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress_ratio += delta*_speed
	if progress_ratio >= .99:
		queue_free()

func take_damage():
	print("destroyed")
	queue_free()
