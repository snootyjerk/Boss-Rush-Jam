extends Line2D

@export var _tethered_node: Node2D



func _ready() -> void:
	points[1] = _tethered_node.position
	
	
func _process(delta: float) -> void:
	points[1] = _tethered_node.position
