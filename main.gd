extends Node
class_name Main

signal player_health_changed(new_health: int)
signal player_energy_changed(new_energy: int)

signal boss_health_changed(new_health: int)
signal boss_phase_changed(new_phase: int)
signal boss_defeated

var _title_scene = preload("res://title_screen.tscn")
var _first_level_scene = preload("res://Levels/level_test.tscn")
var _game_over_scene = preload("res://Scenes/game_over.tscn")

static var node: Main

@onready var hud: Control = $HUD
@onready var pause: PanelContainer = $Pause

var fem_dancer: CharacterBody2D
var man_dancer: CharacterBody2D

var is_game_paused: bool = false:
	get:
		return is_game_paused
	set(value):
		is_game_paused = value
		pause.visible = value

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
	
	
func _ready():
	if Test.level < 1: # Remove for final build
		go_to_level(_first_level_scene)
	else:
		go_to_level(Test.levels[Test.level - 1])
		
	player_health_changed.emit(player_health)
	
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		_pause(!is_game_paused)


func go_to_level(level_scene: PackedScene):
	var new_level: Level = level_scene.instantiate()
	if node.current_level:
		node.current_level.queue_free()
		node.remove_child(node.current_level)
	node.call_deferred("add_child", new_level)
	node.boss_phase = 1


func go_to_next_level():
	var new_level_path: String = node.current_level.get_next_level_path()
	var new_level_scene := load(new_level_path)
	var new_level: Level = new_level_scene.instantiate()
	if node.current_level:
		node.remove_child(node.current_level)
	node.call_deferred("add_child", new_level)
	node.boss_phase = 1
	
	
func retry():
	Test.level = 0
	get_tree().paused = false
	get_tree().change_scene_to_packed(_title_scene)
	#get_tree().paused = false
	#player_health = Constants.PLAYER_MAX_HEALTH
	#hud.visible = true
	

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
	
	
func _pause(is_paused: bool):
	is_game_paused = is_paused
	get_tree().paused = is_paused
