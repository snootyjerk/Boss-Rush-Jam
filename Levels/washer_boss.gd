extends Boss

@onready var _water_level = $WaterLevel
@onready var _eyes = $WasherEyes
@onready var nozz_list = [$WaterNozzle0,$WaterNozzle1,$WaterNozzle2,$WaterNozzle3,$WaterNozzle4,$WaterNozzle5]
@onready var phase0_list = [nozz_list[0],nozz_list[1]]
@onready var phase1_list = [nozz_list[2],nozz_list[3]]
@onready var phase2_list = [nozz_list[0],nozz_list[1],nozz_list[4],nozz_list[5]]
@onready var phase3_list = [nozz_list[0],nozz_list[1],nozz_list[2],nozz_list[3],nozz_list[4],nozz_list[5]]
@onready var phase_lists = [phase0_list,phase1_list,phase2_list,phase3_list]

var _vulnerable = false
var _current_phase = 0
var _max_phases = 1
var _nozz_count = 0


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
	pass
	
	
func _drop_eyes():
	_eyes._drop()
	_vulnerable = true
	
	
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
		_repair_nozzles()
		_adjust_water_level()
		_revive_eyes()
		_current_phase = phase -1
