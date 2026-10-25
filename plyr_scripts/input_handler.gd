extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

const st_timeout = 2

var timeout = st_timeout
# PLEASE PUT ALL INPUTS FROM HIGHEST COMPLEXITY TO LOWEST AS IT WILL READ IT IN SAID ORDER
const BUTTON_MAP = [
	"btn_1",
	"btn_2",
	"btn_3",
	"btn_4",
	"btn_5",
	"mv_up",
	"mv_down",
	"mv_left",
	"mv_right"
]

const MULTI_BTN_MAP = {
	"mv_up": {"mv_right" : "mv_ur","mv_left" : "mv_ul"},
	"mv_down": {"mv_right" : "mv_dr","mv_left" : "mv_dl"},
	"mv_left": {"mv_up" : "mv_ul","mv_down" : "mv_dl"},
	"mv_right": {"mv_up" : "mv_ur","mv_down" : "mv_dr"},
	"btn_1": {"btn_2" : "btn_12","btn_3" : "btn_13"},
	"btn_2": {"btn_1" : "btn_12","btn_4" : "btn_24"},
	"btn_3": {"btn_1" : "btn_13","btn_4" : "btn_34"},
	"btn_4": {"btn_2" : "btn_24","btn_3" : "btn_34"},
	
}

const MOVE_MAP = {
	["mv_down", "mv_downright", "mv_right"]:"QC_R",
	["mv_down", "mv_downright", "mv_right"]:"QC_L",
	["mv_left", "mv_downleft", "mv_down", "mv_downright", "mv_right"]:"HC_R",
	["mv_right", "mv_downright", "mv_down", "mv_downleft", "mv_left"]:"HC_L"
}

var in_series = []

func check_input() -> String:
	var check_ac = true
	var in_str = ""
	for action in BUTTON_MAP:
		if Input.is_action_pressed(action):
			check_ac = true
			in_str+=action+","
	return in_str if check_ac else "none"

# Tick Process
func _process(delta: float) -> void:
	if int(timeout)!=0 && int(timeout)!=-1: timeout-=delta
	elif int(timeout)!=-1:
		print("PRINTING")
		var out_ln = ""
		for i in range(len(in_series)):
			out_ln+= str(i) + ": " + in_series[i][0] + "|" + str(in_series[i][1]) + ", "
		print(out_ln)
		print(JSON.stringify(merge_inputs(in_series)))
		#print_in_series(merge_inputs(in_series))
		in_series=[]
		timeout = -1

func parse_inseries_table_to_str(tbl: Array):
	var out_str=""
	for i in tbl:
		out_str+=str(i)+","
	return out_str

func print_in_series(in_arr):
	for i in range(len(in_arr)):
		print(str(i) + ": " + parse_inseries_table_to_str(in_arr[i][0]) + "|" + str(in_arr[i][1]) + ", ")

# Input Event
func _input(input: InputEvent) -> void:
	if timeout==0: timeout = st_timeout
	if input.is_released() || input.is_echo(): return
	var out_check = check_input()
	if out_check!="none":
		in_series.append([out_check,round_to_dec(st_timeout-timeout, 2)])

		#print(round_to_dec(timeout, 2))
		timeout = st_timeout

func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)

func parse_in_str(in_str):
	in_str=in_str.strip_edges().split(",")
	in_str.erase("")
	return in_str

func clean_inputs(inputs):
	if "mv_up" in inputs && "mv_down" in inputs:
		inputs.erase("mv_up")
		inputs.erase("mv_down")
	if "mv_right" in inputs && "mv_left" in inputs:
		inputs.erase("mv_right")
		inputs.erase("mv_left")
		
	return inputs
	
	
func merge_inputs(in_tbl):
	var merged_inputs = []
	var c = 0
	for in_string in in_tbl:
		in_string[0] = parse_in_str(in_string[0])
		print("in_string: "+JSON.stringify(in_string[0]))
		merged_inputs.append([[],in_string[1]])
		var c_out = []
		in_string[0]=clean_inputs(in_string[0])
		if len(in_string[0])==0: 
			c+=1
			continue
		for i in in_string[0]:
			var out_rec = recurse_lwr_lyr(MULTI_BTN_MAP, in_string[0])
			#print(JSON.stringify(out_rec))
			if not out_rec==null:
				#print(str(out_rec[0]==""))
				for rem_val in out_rec[1]: if rem_val not in c_out: c_out.append(rem_val)
				if not out_rec[0]=="" && out_rec[0] not in merged_inputs[c][0]: merged_inputs[c][0].append(out_rec[0])
		print(JSON.stringify(merged_inputs[c][0]))
		for j in in_string[0]: if j not in merged_inputs[c][0] && j not in c_out: merged_inputs[c][0].append(j)
		c+=1
	#print(JSON.stringify(merged_inputs))
	return merged_inputs
	
func recurse_lwr_lyr(lyr,check, depth=0, out=[]):
	if depth>=len(check): return null
	if check[depth] not in lyr: return null
	if typeof(lyr[check[depth]])==typeof("str"): 
		out.append(check[depth])
		#print("OUTPUT: "+lyr[check[depth]])
		#print("USED TABLE: "+JSON.stringify(out))
		#print("RETURN VALUE: "+JSON.stringify([lyr[check[depth]], out]))
		return [lyr[check[depth]], out]
	else:
		out.append(check[depth])
		return recurse_lwr_lyr(lyr[check[depth]], check, depth+1, out)
	
