extends Boss
class_name BossVacuum

@onready var _head: VacuumHead = $HeadCharacter2D


func _boss_defeated_hook():
	_head.on_boss_defeated()
