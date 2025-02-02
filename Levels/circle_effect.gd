extends Sprite2D


var radius = 20
var active = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if active == true:
		radius +=2000 *delta
		queue_redraw()

func _draw() -> void:
	if active == true:
		draw_circle(position,radius,Color(1,1,1,1),true,1,false)
