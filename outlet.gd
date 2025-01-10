extends Sprite2D

signal unplugged

@onready var plug_body: RigidBody2D = $Plug/Body
@onready var joint: PinJoint2D = $Plug/PinJoint2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	joint.node_b = ""
	
	plug_body.gravity_scale = 1.0
	
	for child in $Plug.get_children():
		if child is CableSegment:
			child.gravity_scale = 1.0
			
	unplugged.emit()
