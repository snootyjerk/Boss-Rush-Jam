extends Boss

var _sock = preload("res://Bosses/sock.tscn")
var _shirt = preload("res://Bosses/shirt.tscn")
var _pants = preload("res://Bosses/pants.tscn")
var laundry_list = [_sock,_shirt,_pants]

@onready var _warning_light = $WarningLight
@onready var _water_level = $WaterLevel
@onready var _eyes = $WasherEyes
@onready var _clothes_path = $Path2D
@onready var nozz_list = [$WaterNozzle0,$WaterNozzle1,$WaterNozzle2,$WaterNozzle3,$WaterNozzle4,$WaterNozzle5]
@onready var phase0_list = [nozz_list[5],nozz_list[4]]
@onready var phase1_list = [nozz_list[2],nozz_list[3]]
@onready var phase2_list = [nozz_list[0],nozz_list[1],nozz_list[4],nozz_list[5]]
@onready var phase3_list = [nozz_list[0],nozz_list[1],nozz_list[2],nozz_list[3],nozz_list[4],nozz_list[5]]
@onready var phase_lists = [phase0_list,phase1_list,phase2_list,phase3_list]

var _vulnerable = false
var _current_phase = 0
var _max_phases = 1
var _nozz_count = 0


# Laundry attack Variables
var _clothes_timer_phase1 = 15
var _clothes_timer_phase2 = 10
var _clothes_timer_phase3 = 8
var _clothes_timer_phase4 = 5
var clothes_timer_list = [_clothes_timer_phase1,_clothes_timer_phase2,_clothes_timer_phase3,_clothes_timer_phase4]
var _clothes_timer_max = _clothes_timer_phase1
var _clothes_timer_min = -.3
var _clothes_timer = 3
var _clothes_density = 4

signal clothes_warning

func _ready() -> void:
	super._ready()
	_repair_nozzles()
	_adjust_water_level()
	Main.node.boss_phase_changed.connect(_on_boss_phase_changed)
	
	var callable = Callable(self,"on_nozzle_broken")
	for i in nozz_list:
		i.just_broken.connect(callable)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_clothes_timer -=1*delta
	if _clothes_timer <= 3 and _warning_light._warning == false:
		clothes_warning.emit()
	if _clothes_timer <= 0:
		_clothes_attack()
	if _clothes_timer <= _clothes_timer_min:
			_clothes_timer = _clothes_timer_max
	
	
func _drop_eyes():
	_eyes._drop()
	_vulnerable = true
	
func _clothes_attack():
	if randi_range(0,_clothes_density) == 0:
		var selection = randi_range(0,2)
		var new_clothes = laundry_list[selection].instantiate()
		_clothes_path.add_child(new_clothes)
	
	
func _revive_eyes():
	_eyes._repair()
	_vulnerable = false


func on_nozzle_broken():
	print("lost a nozzle!")
	_nozz_count -= 1
	_adjust_water_level()
	if _nozz_count <= 0:
		_drop_eyes()


func _repair_nozzles():
	var phase_list = phase_lists[_current_phase]
	var nozzle
	for i in phase_list:
		nozzle = i
		nozzle._repair()
		_nozz_count +=1
	
		
func _adjust_water_level():
	_water_level._set_level(_nozz_count)


func _on_boss_phase_changed(phase):
	if Main.node.boss_health > 0:
		print(phase)
		print("new phase")
		print(_clothes_timer_max)
		_current_phase = phase -1
		_clothes_timer_max = clothes_timer_list[_current_phase]
		_repair_nozzles()
		_adjust_water_level()
		_revive_eyes()
		
