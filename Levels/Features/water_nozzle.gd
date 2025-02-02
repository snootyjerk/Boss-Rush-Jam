extends StaticBody2D

var _broken: bool = true:
	get:
		return _broken
	set(is_broken):
		_broken = is_broken
		if not is_node_ready():
			await ready
		if _broken:
			print(name, " nozzle retracting.")
			_sprite.play_backwards()
		else:
			print(name, " nozzle protracting.")
			_sprite.play()

@onready var _sprite: AnimatedSprite2D = $Sprite2D
@onready var _particles = $CPUParticles2D
@onready var _detector = $Detector
@onready var _shot_point = $ShotPoint

var _shot = preload("res://Bosses/shot.tscn")
var _shot_timer_max = 3
var _shot_timer = 0
var _shot_offset = deg_to_rad(20)

var _submerged = false
var _max_hp = 3
var _hp = _max_hp
var _in_range = false

signal just_broken
signal submerged
signal emerged


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	material.set("shader_parameter/flash_value", 0)
	_detector.monitoring = false
	
	# Call setter function
	if _broken:
		_broken = true
		visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _in_range == true and _broken == false:
		_shot_timer -=1*delta
		if _shot_timer <=0:
			#print("should be shooting")
			_fire_shots()
			_shot_timer = _shot_timer_max


func _submerge():
	_submerged = true
	submerged.emit()

func _fire_shots():
	#print("shots fired")
	var player_angle = global_position.direction_to(Main.node.player_position)
	var new_shot
	var angle = player_angle.rotated(_shot_offset)
	for i in range(2):
		new_shot = _shot.instantiate()
		Main.node.current_level.add_child(new_shot)
		new_shot._angle = angle
		new_shot.global_position = _shot_point.global_position
		angle = player_angle.rotated(-_shot_offset)

func _emerge():
	_submerged = false
	emerged.emit()


func _repair():
	_broken = false
	#print(name, " repaired!")
	_detector.monitoring = true
	_hp = _max_hp
	
	set_collision_layer_value(Constants.Layers.player_hurt, true)
	set_collision_layer_value(Constants.Layers.enemy, true)


func take_damage():
	if _broken == false:
		#print("hit")
		$FlashAnimation.play("flash")
		_hp -=1 
	if _hp <= 0:
		_break()
		
		
func _break():
	#print("broken")
	just_broken.emit()
	_broken = true
	set_collision_layer_value(Constants.Layers.player_hurt, false)
	set_collision_layer_value(Constants.Layers.enemy, false)


func _on_emerged() -> void:
	_particles.emitting = true


func _on_submerged() -> void:
	_particles.emitting = false


func _on_sprite_2d_animation_finished() -> void:
	visible = not _broken


func _on_detector_body_entered(body: Node2D) -> void:
	if body is PlayerController:
		_in_range = true
		#print("in range")
		

func _on_detector_body_exited(body: Node2D) -> void:
	if body is PlayerController:
		_in_range = false
		#print("out of range")
