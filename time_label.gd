extends Label


#var _init_time_ms: int
#var _current_time_ms: int

var _time_passed: int = 0
var is_stopped = false


#func _ready() -> void:
	#_init_time_ms = Time.get_ticks_msec()
	#_current_time_ms = Time.get_ticks_msec() - _init_time_ms


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_stopped:
		_time_passed += round(delta * 1000)
		var seconds = (_time_passed / 1000) % 60
		var minutes = (_time_passed / 1000) / 60
		
		var str_seconds = str(seconds)
		if seconds < 10:
			str_seconds = "0" + str_seconds
		var str_minutes = str(minutes)
		if minutes < 10:
			str_minutes = "0" + str_minutes
			
		text = str_minutes + ":" + str_seconds
		Main.node.run_time_elapsed_str = text
