extends Node2D



@export var left_eye: WasherEye
@export var right_eye: WasherEye

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	left_eye.damaged.connect(_on_damaged)
	right_eye.damaged.connect(_on_damaged)


func _process(delta: float) -> void:
	pass
	
	
func _drop():
	animation_player.play("drop")
	
	
func _repair():
	left_eye.repair()
	right_eye.repair()
	animation_player.play("lift")
	
	
func _on_damaged():
	left_eye.flash_animation()
	right_eye.flash_animation()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "drop":
		left_eye.drop()
		right_eye.drop()
