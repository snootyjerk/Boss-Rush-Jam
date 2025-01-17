extends CharacterBody2D

signal recalled

@export var _speed: float = 100.0

@onready var travel_timer: Timer = $TravelTimer
@onready var delay_timer: Timer = $DelayTimer
@onready var hold_timer: Timer = $HoldTimer
@onready var recall_timer: Timer = $RecallTimer


enum States { WITH_PLAYER, TRAVEL, DELAY, HOLD, RECALL }
var _state: States = States.WITH_PLAYER

var _direction_sign: int # -1 or 1


func _ready() -> void:
	travel_timer.start()


func _process(delta: float) -> void:
	match _state:
		States.TRAVEL:
			velocity.x = _speed * _direction_sign
		States.DELAY:
			velocity = Vector2.ZERO
		States.RECALL:
			var dir = global_position.direction_to(Main.node.player_position)
			velocity = dir * _speed
			#print("Velocity = ", velocity)
	move_and_slide()
	
	
func throw(direction_sign: int):
	_direction_sign = direction_sign
	visible = true
	_state = States.TRAVEL


func _on_travel_timer_timeout() -> void:
	_state = States.DELAY
	delay_timer.start()


func _on_delay_timer_timeout() -> void:
	_state = States.RECALL
	recall_timer.start()


func _on_hold_timer_timeout() -> void:
	pass # Replace with function body.


func _on_recall_timer_timeout() -> void:
	_recall()


func _on_recall_area_body_entered(body: Node2D) -> void:
	_recall()


func _on_damage_area_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage()
		_state = States.RECALL
	
	
	
func _recall():
	recalled.emit()
	visible = false
	_state = States.WITH_PLAYER
