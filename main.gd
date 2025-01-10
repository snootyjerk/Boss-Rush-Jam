extends Node
class_name Main

signal player_health_changed(new_health: int)
signal player_energy_changed(new_energy: int)

@export var _first_level_scene: PackedScene
@export var _game_over_scene: PackedScene

static var node: Main

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
	
var player_energy: int = 100:
	get:
		return player_energy
	set(new_energy):
		player_energy = new_energy
		player_energy_changed.emit(player_energy)


var _game_over_node: Node


func _init():
	node = self
	child_entered_tree.connect(_on_child_entered_tree)
	
	
func _ready():
	go_to_level(_first_level_scene)
	player_health_changed.emit(player_health)


func go_to_level(level_scene: PackedScene):
	var new_level: Level = level_scene.instantiate()
	if node.current_level:
		node.remove_child(node.current_level)
	node.call_deferred("add_child", new_level)


func go_to_next_level():
	var new_level_path: String = node.current_level.get_next_level_path()
	var new_level_scene := load(new_level_path)
	var new_level: Level = new_level_scene.instantiate()
	if node.current_level:
		node.remove_child(node.current_level)
	node.call_deferred("add_child", new_level)
	
	
func retry():
	if _game_over_node:
		node.remove_child(_game_over_node)
	call_deferred("go_to_level", _first_level_scene)
	get_tree().paused = false
	player_health = Constants.PLAYER_MAX_HEALTH
	

func quit():
	get_tree().quit() # later will be main menu


func _on_child_entered_tree(child: Node):
	if child is Level:
		node.current_level = child


func _show_game_over_screen():
	_game_over_node = _game_over_scene.instantiate()
	get_tree().paused = true
	node.add_child(_game_over_node)
