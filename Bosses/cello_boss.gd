extends Boss
class_name CelloBoss

@onready var _cello_body = $Cello 
signal cello_damaged

func _on_dancer_controller_dancers_downed() -> void:
	_cello_body.vulnerable = true
	print("boss can be harmed")


func _on_cello_damaged() -> void:
	cello_damaged.emit()
