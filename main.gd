extends Node
class_name Main

@export var _current_level_scene: PackedScene
@export var _game_over_scene: PackedScene

static var node: Main

var current_level: Level

var player_health: int = 1:#Constants.PLAYER_MAX_HEALTH:
	get:
		return player_health
		
func damage_player():
	player_health = max(0, player_health - 1)
	print("Player health = ", player_health)
	if player_health < 1:
		go_to_level(_game_over_scene)
		
func heal_player():
	player_health = min(player_health, Constants.PLAYER_MAX_HEALTH)
	print("Player health = ", player_health)


func _init():
	node = self
	child_entered_tree.connect(_on_child_entered_tree)
	
	
func _ready():
	go_to_level(_current_level_scene)
	
	
func _on_child_entered_tree(child: Node):
	if child is Level:
		node.current_level = child


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
