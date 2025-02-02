extends Node2D

var _acceleration = -.05
var _max_velocity = 10
var _velocity = 0

var _grav_vector = Vector2(0,15)
var _drop_timer = 4

@onready var circle = $CircleEffect
@onready var _particles = $Sprite2D/CPUParticles2D
var _part_x_offset = 0 
var _part_y_offset = 0

func _ready() -> void:
	#_particles.rotation = rotation
	#_particles.global_position = Vector2(global_position.x + _part_x_offset,global_position.y + _part_y_offset)
	pass

func _process(delta: float) -> void:
	
	if _drop_timer >0:
		global_position += _grav_vector*delta
		_drop_timer -= 1*delta
	else:
		_passive_movement(delta)
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	circle.active = true
	$AudioStreamPlayer2D.play()
	Engine.time_scale = .05
	await(get_tree().create_timer(.15).timeout)
	Engine.time_scale = 1.0
	Main.node.game_completed()

func _passive_movement(delta): # Slightly moves water up and down
	_velocity += _acceleration
	if _velocity >= _max_velocity or _velocity <= -_max_velocity:
		_acceleration = -_acceleration
	global_position.y += _velocity*delta
