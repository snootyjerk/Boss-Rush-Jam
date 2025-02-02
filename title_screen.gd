extends Control

var _main_scene = preload("res://main.tscn")

@onready var casual_best_time: Label = $CasualBestTime
@onready var hardcore_best_time: Label = $HardcoreBestTime



func _ready() -> void:
	get_tree().paused = false
	#if FileAccess.file_exists("user://best_time_casual.dat"):
		#var file = FileAccess.open("user://best_time_casual.dat", FileAccess.READ)
		#var time = file.get_line()
		#casual_best_time.text = time
		#casual_best_time.visible = true
		#
	#if FileAccess.file_exists("user://best_time_hardcore.dat"):
		#var file = FileAccess.open("user://best_time_hardcore.dat", FileAccess.READ)
		#var time = file.get_line()
		#hardcore_best_time.text = time
		#hardcore_best_time.visible = true



func _on_casual_button_button_up() -> void:
	GlobalState.is_hardcore = false
	get_tree().change_scene_to_packed(_main_scene)


func _on_hardcore_button_button_up() -> void:
	GlobalState.is_hardcore = true
	get_tree().change_scene_to_packed(_main_scene)


func _on_casual_button_mouse_entered() -> void:
	$CasualModeDescription.visible = true


func _on_casual_button_mouse_exited() -> void:
	$CasualModeDescription.visible = false


func _on_hardcore_button_mouse_entered() -> void:
	$HardcoreModeDescription.visible = true


func _on_hardcore_button_mouse_exited() -> void:
	$HardcoreModeDescription.visible = false
