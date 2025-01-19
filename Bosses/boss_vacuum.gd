extends Boss
class_name BossVacuum

@onready var _head: VacuumHead = $HeadCharacter2D
@onready var _jump_starting_point = global_position
var _moving = true
var _jump_point_1 = Vector2(567,168)
var _jump_arc_height = -200

var _move_timer = 0.0

func _process(delta: float) -> void:
	if _moving == true:
		_jump_movement(_jump_point_1)
		_move_timer += delta *.4
		if _move_timer >= 1:
			_moving = false
			_head._tether_point = global_position

func _boss_defeated_hook():
	_head.on_boss_defeated()
	
func _jump_movement(endpoint: Vector2):
	var jump_arc_point = Vector2((_jump_point_1.x-_jump_starting_point.x) *.5 +_jump_starting_point.x,max(_jump_point_1.y,_jump_starting_point.y)+_jump_arc_height)
	var curve_point0 = _jump_starting_point.lerp(jump_arc_point,_move_timer)
	var curve_point1 = jump_arc_point.lerp(endpoint,_move_timer)
	global_position = curve_point0.lerp(curve_point1,_move_timer)
