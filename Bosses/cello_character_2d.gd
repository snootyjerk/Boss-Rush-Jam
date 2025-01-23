extends CharacterBody2D

var _note_projectile = preload("res://Bosses/note.tscn")
var _note_timer_max = 3
var _note_timer = _note_timer_max


func _physics_process(delta: float) -> void:
	_note_timer -= 1*delta
	if _note_timer <= 0:
		var new_note = _note_projectile.instantiate()
		Main.node.current_level.add_child(new_note)
		new_note.global_position = global_position
		_note_timer = _note_timer_max
