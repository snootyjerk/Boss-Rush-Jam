extends Node2D
class_name Level

signal boss_defeated

const LEVEL_DIR: String = "res://Levels/level_"

@export var _next_level_name: String
@export var _boss: Boss

@onready var boss_music: AudioStreamPlayer = $BossMusic
@onready var exit_blocking_tile_map: TileMap = $ExitBlockingTileMap


func get_next_level_path() -> String:
	return LEVEL_DIR + _next_level_name + ".tscn"


var _is_boss_defeated: bool = false
var is_boss_defeated: bool:
	get:
		return _is_boss_defeated
	set(defeated):
		_is_boss_defeated = defeated
		if defeated:
			boss_music.stop()
			boss_defeated.emit()
			exit_blocking_tile_map.clear()
			
			
func _ready() -> void:
	Main.node.boss_defeated.connect(_on_boss_death)
	
	Main.node.boss_max_health = _boss.boss_health
	Main.node.boss_health = _boss.boss_health
	HUD.node.set_boss_name_text(_boss.boss_name)


func _on_boss_death():
	is_boss_defeated = true


# make invisible for level transition
func _exit_tree():
	visible = false


func _on_outlet_unplugged() -> void:
	is_boss_defeated = true
