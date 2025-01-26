extends Node2D

signal dancers_downed

@onready var _man_path = $ManPath/ManPathFollow
@onready var _fem_path = $FemPath/FemPathFollow
@onready var _man_dancer = $ManPath/ManPathFollow/ManDancer
@onready var _fem_dancer = $FemPath/FemPathFollow/FemDancer
enum _states {IDLE,DANCING,STUN,ATTACK,RECOVER,RESET}


@export var _dancer_speed = 50

var _boss_stage: int = 0
var _num_stunned: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#_man_dancer._right_reset_point = Vector2(632,144)
	#_man_dancer._left_reset_point = Vector2(8,144)
	#_fem_dancer._right_reset_point = Vector2(632,144)
	#_fem_dancer._left_reset_point = Vector2(8,144)
	
	_man_dancer._update_state(_states.DANCING)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#match _boss_stage:
		#0:	
			#if _man_dancer._current_state == _states.DANCING:
				#_man_path.progress += _dancer_speed * delta
				#if _fem_dancer._current_state != _states.STUN and (_man_path.progress_ratio >= .497 and _man_path.progress_ratio <= .503) or (_man_path.progress_ratio >= .997 or _man_path.progress_ratio <= .003):
					#_man_dancer._update_state(_states.IDLE)
					#_fem_dancer._update_state(_states.DANCING)
			#if _fem_dancer._current_state == _states.DANCING:
				#_fem_path.progress += _dancer_speed * delta
				#if _man_dancer._current_state != _states.STUN and (_fem_path.progress_ratio >= .497 and _fem_path.progress_ratio <= .503) or (_fem_path.progress_ratio >= .997 or _fem_path.progress_ratio <= .003):
					#_fem_dancer._update_state(_states.IDLE)
					#_man_dancer._update_state(_states.DANCING)


func _on_man_dancer_stunned() -> void:
	_num_stunned += 1
	if _num_stunned >= 2:
		dancers_downed.emit()
		_num_stunned = 0


func _on_fem_dancer_stunned() -> void:
	_num_stunned += 1
	if _num_stunned >= 2:
		dancers_downed.emit()
	#if _man_dancer._current_state != _states.STUN:
		#print("fem down")
		#_man_dancer._update_state(_states.DANCING)
	#else:
		#print("both down")
		#dancers_downed.emit()

func _reset_dancers():
	_man_dancer._revive()
	_fem_dancer._revive()


func _on_man_dancer_reset_complete() -> void:
	_man_dancer._update_state(_states.DANCING)


func _on_cello_boss_cello_damaged() -> void:
	_reset_dancers()
	print("dancers reset")


func _on_cello_boss_cello_reset() -> void:
	_reset_dancers()
