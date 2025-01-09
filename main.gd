extends Node
class_name Main

@export var _current_level_scene: PackedScene

static var node: Main

var current_level: Level


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
