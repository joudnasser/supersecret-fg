extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var t_count = -1


const MV_BTN_MAP = {
	"mv_up": 3,
	"mv_down": -3,
	"mv_left": -1,
	"mv_right": 1
}

const ATK_BTN_MAP = {
	"btn_1": "A",
	"btn_2": "B",
	"btn_3": "C",
	"btn_4": "D",
	"btn_5": "E"
}


const MOVE_MAP = {
	"63214":"HCl",
	"41236":"HCr",
	"236": "QCr",
	"214": "QCl",
	
}

var l6_moves = []

# Tick Process
func _process(delta: float) -> void:
	if t_count!=-1: t_count+=delta

# Input Event
func _input(input: InputEvent) -> void:
	if input.is_echo(): return
	
	var delta = str(t_count).pad_decimals(2).pad_zeros(3)
	var input_map: Array[String] = [str(handle_mv("p1")),handle_atk("p1")]
	
	# TEST PRINT
	#if str(handle_mv("p1"))!="5" || handle_atk("p1")!="": print(delta.rpad(6, "0")+" | "+input_map)
	if validate_input("p1"):
		if len(l6_moves)==6:
			l6_moves.remove_at(0)
		l6_moves.append([delta, input_map])
		t_count=0
		if len(l6_moves)>=3:
			print(JSON.stringify(l6_moves))
			var cmplx_move = find_complex_move()
			if cmplx_move!="":print(cmplx_move)


# INPUT HANDLER (RAW -> FIGHTING GAME NOTATION)

func handle_mv(plyr) -> int:
	var mv_pos: int = 5
	for each in MV_BTN_MAP:
		if Input.is_action_pressed(plyr+"_"+str(each)): mv_pos+=MV_BTN_MAP[each]
	return mv_pos

func handle_atk(plyr) -> String:
	var atk_pos = ""
	for each in ATK_BTN_MAP:
		if Input.is_action_pressed(plyr+"_"+str(each)): atk_pos+=ATK_BTN_MAP[each]
	return atk_pos

func validate_input(plyr):
	for each in ATK_BTN_MAP:
		if Input.is_action_pressed(plyr+"_"+str(each)): return true
	for each in MV_BTN_MAP:
		if Input.is_action_pressed(plyr+"_"+str(each)): return true
	return false
	
	

# INPUT PROCESSOR

func find_complex_move():
	for move in MOVE_MAP:
		var equate = len(move)
		#print(move)
		for i in min(len(move),len(l6_moves)):
			#print( move[-i] + " | " + l6_moves[-i][1][0])
			if move[-i]==l6_moves[-i][1][0]:
				equate-=1
			elif equate!=len(move):
				equate=len(move)
		if equate==0:
			return MOVE_MAP[move]
	return ""

# MISC FUNCTIONS 

func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)
