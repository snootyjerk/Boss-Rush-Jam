extends Boss
class_name CelloBoss

@onready var _cello_body = $Cello
@onready var _vulnerable_timer: Timer = $VulnerableTimer

signal cello_reset


func _on_dancer_controller_dancers_downed() -> void:
	_cello_body.vulnerable = true
	_vulnerable_timer.start()


func _on_vulnerable_timer_timeout() -> void:
	if _cello_body.vulnerable:
		cello_reset.emit()


func _on_cello_reset() -> void:
	cello_reset.emit()
