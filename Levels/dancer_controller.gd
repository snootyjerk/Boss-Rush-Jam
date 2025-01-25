extends Node2D

@onready var _man_path = $ManPath/ManPathFollow
@onready var _fem_path = $FemPath/FemPathFollow
@onready var _man_dancer = $ManPath/ManPathFollow/ManDancer
@onready var _fem_dancer = $FemPath/FemPathFollow/FemDancer
enum _states {IDLE,DANCING,STUN,ATTACK,RECOVER,RESET}


@export var _dancer_speed = 200

var _boss_stage: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_man_dancer._right_reset_point = Vector2(632,144)
	_man_dancer._left_reset_point = Vector2(8,144)
	_fem_dancer._right_reset_point = Vector2(632,144)
	_fem_dancer._left_reset_point = Vector2(8,144)
	
	_man_dancer._update_state(_states.DANCING)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match _boss_stage:
		0:
			if _man_dancer._current_state == _states.DANCING:
				_man_path.progress += _dancer_speed * delta
				if (_man_path.progress_ratio >= .497 and _man_path.progress_ratio <= .503) or (_man_path.progress_ratio >= .997 or _man_path.progress_ratio <= .003):
					_man_dancer._update_state(_states.IDLE)
					_fem_dancer._update_state(_states.DANCING)
			if _fem_dancer._current_state == _states.DANCING:
				_fem_path.progress += _dancer_speed * delta
				if (_fem_path.progress_ratio >= .497 and _fem_path.progress_ratio <= .503) or (_fem_path.progress_ratio >= .997 or _fem_path.progress_ratio <= .003):
					_fem_dancer._update_state(_states.IDLE)
					_man_dancer._update_state(_states.DANCING)
