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

var _submerged = false
var _max_hp = 1
var _hp = _max_hp
var _in_range = false

signal just_broken
signal submerged
signal emerged


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	material.set("shader_parameter/flash_value", 0)
	
	# Call setter function
	if _broken:
		_broken = true
		visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _submerge():
	_submerged = true
	submerged.emit()


func _emerge():
	_submerged = false
	emerged.emit()


func _repair():
	_broken = false
	print(name, " repaired!")
	_hp = _max_hp
	
	set_collision_layer_value(Constants.Layers.player_hurt, true)
	set_collision_layer_value(Constants.Layers.enemy, true)


func take_damage():
	if _broken == false:
		print("hit")
		$FlashAnimation.play("flash")
		_hp -=1 
	if _hp <= 0:
		_break()
		
		
func _break():
	print("broken")
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
