extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

const st_timeout = 5

var found = false
var timeout = st_timeout
# Called every frame. 'delta' is the elapsed time since the previous frame.
const BUTTON_MAP = {
	"btn_1": "Z",
	"btn_2": "X",
	"btn_3": "C",
	"btn_4": "V",
	"btn_5": "B",
	"mv_up": "↑",
	"mv_down": "↓",
	"mv_left": "←",
	"mv_right": "→",
}

const MOVE_MAP = {
	["mv_down", "mv_downright", "mv_right"]:"QC_R",
	["mv_down", "mv_downright", "mv_right"]:"QC_L",
	["mv_left", "mv_downleft", "mv_down", "mv_downright", "mv_right"]:"HC_R",
	["mv_right", "mv_downright", "mv_down", "mv_downleft", "mv_left"]:"HC_L"
}

var in_series = []

func check_input() -> String:
	for action in BUTTON_MAP:
			if Input.is_action_just_pressed(action):
				return BUTTON_MAP[action]
	return "none"


func _process(delta: float) -> void:
	if int(timeout)!=0:
		var out_check = check_input()
		if out_check!="none":
			in_series.append([out_check,round_to_dec(st_timeout-timeout, 2)])
			found = true
		if found:
			print(round_to_dec(timeout, 2))
			timeout = st_timeout
			found = false
		timeout-=delta
	else:
		print("PRINTING")
		var out_ln = ""
		for i in range(len(in_series)):
			out_ln+= str(i) + ": " + in_series[i][0] + "|" + str(in_series[i][1]) + ", "
		print(out_ln)
		in_series=[]
		timeout = st_timeout

func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)
