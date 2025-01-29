extends CharacterBody2D

@export var _move_speed: float = 100.0

@onready var visibility_animation: AnimationPlayer = $VisibilityAnimation

var _note_projectile = preload("res://Bosses/note.tscn")
var _note_multi_projectile = preload("res://Bosses/note_multi.tscn")

var _starting_position: Vector2
var _note_timer_max = 2.8
var _note_timer = _note_timer_max
var vulnerable = false:
	get:
		return vulnerable
	set(value):
		vulnerable = value
		$ShieldSprite.visible = !value

signal damaged
signal reset


func _ready() -> void:
	_starting_position = global_position
	var dir = _choose_direction()
	velocity = Vector2(cos(dir), -sin(dir)) * _move_speed
	Main.node.boss_phase_changed.connect(_on_boss_phase_changed)


func _physics_process(delta: float) -> void:
	_note_timer -= 1*delta
	if not vulnerable:
		if _note_timer <= 0:
			var new_note = _note_projectile.instantiate()
			Main.node.current_level.add_child(new_note)
			new_note.global_position = global_position
			_note_timer = _note_timer_max
	else:
		if _note_timer <= 0:
			for angle in [[0, 90, 180, 270], [45, 135, 225, 315]].pick_random():
				var new_note = _note_multi_projectile.instantiate()
				new_note.direction_degrees = angle
				Main.node.current_level.add_child(new_note)
				new_note.global_position = global_position
				_note_timer = _note_timer_max
		
		var collision = move_and_collide(velocity * delta)
		if collision:
			velocity = velocity.bounce(collision.get_normal())


func take_damage():
	if vulnerable == true:
		Main.node.damage_boss()
		damaged.emit()
		
		
func _on_boss_phase_changed(phase: int):
	match phase:
		2:
			pass
		3:
			_note_timer_max = 2.6
		4:
			_note_timer_max = 2.3


func _on_teleport():
	global_position = _starting_position


func timeout():
	if Main.node.boss_health > 0:
		vulnerable = false
		visibility_animation.play("teleport")
		reset.emit()

func _choose_direction() -> float:
	return deg_to_rad([45.0, 135.0, 225.0, 315.0].pick_random())
