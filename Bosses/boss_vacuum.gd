extends Boss
class_name BossVacuum

var _boss_death_head = preload("res://Bosses/vacuum_boss_death_head.tscn")

@export var _spike_bwall_spawner1: Node
@export var _spike_bwall_spawner2: Node
@export var _jump_delay_phase_2: float = 7.5
@export var _jump_delay_phase_3: float = 6.0
@export var _jump_delay_phase_4: float = 4.0

@onready var _head: VacuumHead = $HeadCharacter2D

@onready var _jump_starting_point = global_position
@onready var _jump_points = [Vector2(61,88),_jump_starting_point,Vector2(567,168)]
var _jump_direction = 1

var _jumping = false
var _can_jump = true
var _current_point = 1
var _next_point = _current_point + _jump_direction
var _last_point = _current_point - _jump_direction
var _jump_arc_height = -200
var _jump_process = 0.0
var _action_timer_max = 3
var _action_timer = _action_timer_max


func _ready() -> void:
	material.set("shader_parameter/flash_value", 0)
	Main.node.boss_phase_changed.connect(_on_phase_changed)


func _boss_defeated_hook():
	var dead_head = _boss_death_head.instantiate()
	Main.node.current_level.add_child(dead_head)
	dead_head.global_position = _head.global_position


func _process(delta: float) -> void:
	if _jumping == true:
		_head._update_state(_head._states.IDLE)
		_jump_movement(_jump_points[_next_point])
		_jump_process += delta *.4
		if _jump_process >= 1:
			_jumping = false
			_last_point = _current_point
			_current_point = _next_point
			if _current_point == _jump_points.size() -1:
				_jump_direction = -1
			elif _current_point == 0:
				_jump_direction = 1
			_next_point = _current_point + _jump_direction
			_jump_starting_point = _jump_points[_current_point]
			_head._tether_point = global_position
			_jump_process = 0
			_land()
	if Main.node.boss_phase > 1:
		_action_timer -= 1*delta
		if _action_timer <= 0:
			_action_timer = _action_timer_max
			_jumping = true
	
	
func _jump_movement(endpoint: Vector2):
	var jump_arc_point = Vector2((endpoint.x-_jump_starting_point.x) *.5 +_jump_starting_point.x,max(endpoint.y,_jump_starting_point.y)+_jump_arc_height)
	var curve_point0 = _jump_starting_point.lerp(jump_arc_point,_jump_process)
	var curve_point1 = jump_arc_point.lerp(endpoint,_jump_process)
	global_position = curve_point0.lerp(curve_point1,_jump_process)
	
	
func _land():
	if _spike_bwall_spawner1:
		if _spike_bwall_spawner1.has_method("spawn"):
			_spike_bwall_spawner1.spawn()
			
	if Main.node.boss_phase > 3:
		if _spike_bwall_spawner2:
			if _spike_bwall_spawner2.has_method("spawn"):
				_spike_bwall_spawner2.spawn()
	
	
func _on_phase_changed(new_phase: int):
	if new_phase == 2:
		_action_timer_max = _jump_delay_phase_2
	elif new_phase == 3:
		_action_timer_max = _jump_delay_phase_3
	elif new_phase == 4:
		_action_timer_max = _jump_delay_phase_4
