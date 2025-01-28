extends StaticBody2D

@onready var _particles = $CPUParticles2D
var _submerged = false
var _broken = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _submerged or _broken:
		_particles.emitting = false
	else:
		_particles.emitting = true
	


func _submerge():
	_submerged = true
	print("submerged")


func _emerge():
	_submerged = false
