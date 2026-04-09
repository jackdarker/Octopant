class_name Status extends Node

# Character value

signal changed(ID:String,value:float)

static func create(_ID:StringName,_value:float,_ll:float,_ul:float)->Status:
	assert(_ul>_ll)
	var _n=Status.new()
	_n.ID=_ID
	_n.value=_value
	_n.ll=_ll
	_n.ul=_ul
	return _n

var ID:String="UNKNOWN"
var value:float=0
var value_percent:float:
	set(v):
		if(v>=0):
			value = min(ul,max(ll,v*ul/100.0))
		else:
			value = min(ul,max(ll,v*ll/-100.0))	
	get():
		# ll	v	ul	perc
		# 0		20	60	33
		# -30	6	60	10
		# -30	-15	30	-50
		# 20	30	40	50	or 75 ??	#TODO
		# -50	-20	-10	-25	or -45??
		if(value>=0):
			return (100.0*value/ul)
		else:
			return (-100.0*value/ll)
			
var ll:float= -100	#lower limit
var ul:float= 100	#upper limit
var atUL:bool:
	set(value):
		pass
	get:
		return(value>=ul)

var atLL:bool:
	set(value):
		pass
	get:
		return(value<=ll)
		
func modify(change:float):
	value=min(ul,max(ll,value+change))
	changed.emit(ID,value)

func loadData(data):
	ID=data["ID"]
	value=data["value"]		
	ll=data["ll"]
	ul=data["ul"]
			
func saveData()->Variant:
	return({"ID":ID,"value":value,"ll":ll,"ul":ul})
