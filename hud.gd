extends Control
class_name HUD

@export var _health_icon: Texture2D
@export var _no_health_icon: Texture2D

@export var boss_hud_root: Node
@export var boss_health_bar: ProgressBar
@export var boss_name_label: Label
func set_boss_name_text(text: String):
	if not is_node_ready():
		await ready
	boss_name_label.text = text

@onready var heart_grid: Node = $Health/Grid
@onready var charge_bar: ProgressBar = $Charge/ChargeBar
@onready var health_bar_anim: AnimationPlayer = $Health/AnimationPlayer

static var node: HUD
func _init() -> void:
	if not node:
		node = self


var _prev_health: int = Constants.PLAYER_MAX_HEALTH


func _on_main_player_health_changed(new_health: int) -> void:
	if new_health < _prev_health:
		health_bar_anim.play("shake")
	
	for heart_icon: Control in heart_grid.get_children():
		heart_icon.texture = _no_health_icon
		
	for i in range(new_health):
		if i < heart_grid.get_child_count():
			var heart_icon: Control = heart_grid.get_child(i)
			heart_icon.texture = _health_icon
			
	_prev_health = new_health


func _on_main_player_energy_changed(new_energy: int) -> void:
	charge_bar.value = new_energy


func _on_main_boss_health_changed(new_health: int) -> void:
	if Main.node.boss_health < Main.node.boss_max_health:
		if boss_hud_root.has_method("shake"):
			boss_hud_root.shake()
	boss_health_bar.value = (float(new_health) / Main.node.boss_max_health) * 100.0
