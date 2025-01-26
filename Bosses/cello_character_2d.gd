extends CharacterBody2D

var _note_projectile = preload("res://Bosses/note.tscn")
var _note_timer_max = 3
var _note_timer = _note_timer_max
var vulnerable = false

signal damaged

func _physics_process(delta: float) -> void:
	_note_timer -= 1*delta
	if _note_timer <= 0:
		var new_note = _note_projectile.instantiate()
		Main.node.current_level.add_child(new_note)
		new_note.global_position = global_position
		_note_timer = _note_timer_max

func take_damage():
	if vulnerable == true:
		#Main.node.damage_boss()
		print("boss hurt")
		damaged.emit()
		vulnerable = false
