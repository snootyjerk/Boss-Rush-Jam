extends Node2D

var _timer_max = 1
var _timer = _timer_max
var _warning = false
@onready var light1 = $Light1
@onready var light2 = $Light2
@onready var light3 = $Light3
@onready var light_list = [light1,light2,light3]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in light_list:
		i.pause()
		i.frame =1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _warning == true:
		_timer -= 1*delta
		if _timer <= 0:
			_warning = false
			for i in light_list:
				i.pause()
				i.frame =1
			_timer = _timer_max


func _on_washer_boss_clothes_warning() -> void:
	_warning = true
	for i in light_list:
		i.play()
