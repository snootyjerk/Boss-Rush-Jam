extends Control


@onready var h_box_container: Node = $HBoxContainer
@onready var charge_bar: ProgressBar = $ChargeBar


func _on_main_player_health_changed(new_health: int) -> void:
	for heart_icon: Control in h_box_container.get_children():
		heart_icon.visible = false
		
	for i in range(new_health):
		if i < h_box_container.get_child_count():
			var heart_icon: Control = h_box_container.get_child(i)
			heart_icon.visible = true


func _on_main_player_energy_changed(new_energy: int) -> void:
	charge_bar.value = new_energy
