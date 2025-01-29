extends Boss
class_name CelloBoss

var _cello_dead_scene = preload("res://Bosses/cello_dead.tscn")

@onready var _cello_body = $Cello
@onready var _vulnerable_timer: Timer = $VulnerableTimer

signal cello_reset


func _ready() -> void:
	material.set("shader_parameter/flash_value", 0)
	Main.node.boss_defeated.connect(_on_boss_defeated)


func _on_dancer_controller_dancers_downed() -> void:
	_cello_body.vulnerable = true
	_vulnerable_timer.start()


func _on_vulnerable_timer_timeout() -> void:
	if _cello_body.vulnerable:
		_cello_body.timeout()
		cello_reset.emit()
		
		
func _on_boss_defeated():
	var dead = _cello_dead_scene.instantiate()
	Main.node.current_level.add_child(dead)
	dead.global_position = _cello_body.global_position
	dead.rotation_degrees = 5.0
	queue_free()


func _on_cello_reset() -> void:
	cello_reset.emit()
