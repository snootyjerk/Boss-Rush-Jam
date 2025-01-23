extends Control
class_name HUD

@export var boss_hud_root: Node
@export var boss_health_bar: ProgressBar
@export var boss_name_label: Label
func set_boss_name_text(text: String):
	if not is_node_ready():
		await ready
	boss_name_label.text = text

@onready var h_box_container: Node = $HBoxContainer
@onready var charge_bar: ProgressBar = $ChargeBar

static var node: HUD
func _init() -> void:
	if not node:
		node = self


func _on_main_player_health_changed(new_health: int) -> void:
	for heart_icon: Control in h_box_container.get_children():
		heart_icon.visible = false
		
	for i in range(new_health):
		if i < h_box_container.get_child_count():
			var heart_icon: Control = h_box_container.get_child(i)
			heart_icon.visible = true


func _on_main_player_energy_changed(new_energy: int) -> void:
	charge_bar.value = new_energy


func _on_main_boss_health_changed(new_health: int) -> void:
	if Main.node.boss_health < Main.node.boss_max_health:
		if boss_hud_root.has_method("shake"):
			boss_hud_root.shake()
	boss_health_bar.value = (float(new_health) / Main.node.boss_max_health) * 100.0
