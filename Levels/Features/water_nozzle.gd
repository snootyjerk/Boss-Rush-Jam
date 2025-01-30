extends StaticBody2D

@onready var _particles = $CPUParticles2D
var _submerged = false
var _broken = true
var _max_hp = 4
var _hp = _max_hp
var _in_range = false

signal just_broken
signal submerged
signal emerged


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


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
	_hp = _max_hp
	visible = true
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
	visible = false
	set_collision_layer_value(Constants.Layers.player_hurt, false)
	set_collision_layer_value(Constants.Layers.enemy, false)


func _on_emerged() -> void:
	_particles.emitting = true


func _on_submerged() -> void:
	_particles.emitting = false
