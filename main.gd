extends Node
class_name Main

signal player_health_changed(new_health: int)
signal player_energy_changed(new_energy: int)

signal boss_health_changed(new_health: int)
signal boss_phase_changed(new_phase: int)
signal boss_defeated

var _title_scene = load("res://title.tscn")
var _first_level_scene = preload("res://Levels/level_test.tscn")
var _game_over_scene = preload("res://Scenes/game_over.tscn")
var _victory_scene = preload("res://victory_screen.tscn")

static var node: Main

@onready var hud: Control = $HUD
@onready var pause: PanelContainer = $Pause

var fem_dancer: CharacterBody2D
var man_dancer: CharacterBody2D

var run_time_elapsed_str: String

var is_game_paused: bool = false:
	get:
		return is_game_paused
	set(value):
		is_game_paused = value
		pause.visible = value

var _current_level_scene: PackedScene
var current_level: Level
var player_health: int = Constants.PLAYER_MAX_HEALTH:
	get:
		return player_health
	set(new_health):
		player_health = new_health
		player_health_changed.emit(player_health)
func damage_player():
	player_health = max(0, player_health - 1)
	player_health_changed.emit(player_health)
	if player_health < 1:
		_show_game_over_screen()
func heal_player():
	player_health = min(player_health, Constants.PLAYER_MAX_HEALTH)
	player_health_changed.emit(player_health)
	
var boss_name: String
var boss_phase: int: # 4 phases that activate at 100%, 75%, 50%, and 25%
	get:
		return boss_phase
	set(new_phase):
		boss_phase = new_phase
		boss_phase_changed.emit(new_phase)
var boss_max_health: int = 1
var boss_health: int = 1:
	get:
		return boss_health
	set(new_health):
		boss_health = new_health
		boss_health_changed.emit(boss_health)
		
		# Phase change
		var health_ratio: float = float(boss_health) / boss_max_health
		if health_ratio <= 0.25:
			if boss_phase != 4:
				print("Phase 4")
				boss_phase = 4
		elif health_ratio <= 0.5:
			if boss_phase != 3:
				print("Phase 3")
				boss_phase = 3
		elif health_ratio <= 0.75:
			if boss_phase != 2:
				print("Phase 2")
				boss_phase = 2
		
func damage_boss():
	boss_health = max(0, boss_health - 1)
	if boss_health < 1:
		boss_defeated.emit()
	

var player_energy: int = 100:
	get:
		return player_energy
	set(new_energy):
		player_energy = new_energy
		player_energy_changed.emit(player_energy)
		
var player_position: Vector2


var _game_over_node: Node


func _init():
	node = self
	child_entered_tree.connect(_on_child_entered_tree)
	
var current_best_time: int = 0

func _ready():
	var mode = "hardcore" if GlobalState.is_hardcore else "casual"
	if FileAccess.file_exists("user://best_time_" + mode + ".dat"):
		var file = FileAccess.open("user://best_time_" + mode + ".dat", FileAccess.READ)
		var time_str: String = file.get_line()
		current_best_time = _convert_time_str_to_secs(time_str)
	
	go_to_level(_first_level_scene)
		
	player_health_changed.emit(player_health)
	
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		#go_to_next_level()
		_pause(!is_game_paused)
		#go_to_next_level()


func go_to_level(level_scene: PackedScene):
	_current_level_scene = level_scene
	var new_level: Level = level_scene.instantiate()
	if node.current_level:
		node.current_level.queue_free()
		node.remove_child(node.current_level)
	node.call_deferred("add_child", new_level)
	node.boss_phase = 1
	
	
func _restart_level():
	go_to_level(_current_level_scene)


func go_to_next_level():
	var new_level_path: String = node.current_level.get_next_level_path()
	var new_level_scene := load(new_level_path)
	_current_level_scene = new_level_scene
	var new_level: Level = new_level_scene.instantiate()
	if node.current_level:
		node.remove_child(node.current_level)
	node.call_deferred("add_child", new_level)
	node.boss_phase = 1
	
	
func retry():
	if GlobalState.is_hardcore:
		get_tree().change_scene_to_packed(_title_scene)
	else:
		player_health = Constants.PLAYER_MAX_HEALTH
		player_energy = 100
		_hide_game_over_screen()
		hud.visible = true
		_restart_level()
		get_tree().paused = false
	
	
func game_completed():
	#var new_time = _convert_time_str_to_secs(node.run_time_elapsed_str)
	#if new_time < current_best_time:
		#var mode = "hardcore" if GlobalState.is_hardcore else "casual"
		#var file = FileAccess.open("user://best_time_" + mode + ".dat", FileAccess.WRITE)
		#file.store_string(node.run_time_elapsed_str)
	
	GlobalState.time_str = node.run_time_elapsed_str
	get_tree().change_scene_to_packed(_victory_scene)
	

func quit():
	get_tree().quit() # later will be main menu


func _on_child_entered_tree(child: Node):
	if child is Level:
		node.current_level = child


func _show_game_over_screen():
	_game_over_node = _game_over_scene.instantiate()
	get_tree().paused = true
	node.add_child(_game_over_node)
	hud.visible = false
	
	
func _hide_game_over_screen():
	node.remove_child(_game_over_node)
	
func _pause(is_paused: bool):
	is_game_paused = is_paused
	get_tree().paused = is_paused
	

func _convert_time_str_to_secs(time_str: String) -> int:
	var strings = time_str.split(":")
	var min = strings[0].to_int()
	var sec = strings[1].to_int()
	return (min * 60) + sec
