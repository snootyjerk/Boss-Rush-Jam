extends CharacterBody2D

var _note_projectile = preload("res://Bosses/note.tscn")
var _note_timer_max = 3
var _note_timer = _note_timer_max
var vulnerable = false

signal damaged
signal reset


func _ready() -> void:
	Main.node.boss_phase_changed.connect(_on_boss_phase_changed)


func _physics_process(delta: float) -> void:
	_note_timer -= 1*delta
	if _note_timer <= 0:
		var new_note = _note_projectile.instantiate()
		Main.node.current_level.add_child(new_note)
		new_note.global_position = global_position
		_note_timer = _note_timer_max


func take_damage():
	if vulnerable == true:
		Main.node.damage_boss()
		damaged.emit()
		
		
func _on_boss_phase_changed(phase: int):
	vulnerable = false
	reset.emit()
	match phase:
		2:
			pass
		3:
			_note_timer_max = 2.6
		4:
			_note_timer_max = 2.0
