class_name Status extends Node

# Character value

signal changed(ID:String,value:float)

static func create(ID:StringName,_value:float,_ll:float,_ul:float)->Status:
	assert(_ul>_ll)
	var _n=Status.new()
	_n.ID=ID
	_n.value=_value
	_n.ll=_ll
	_n.ul=_ul
	return _n

var ID:String="UNKNOWN"
var value:float=0
var ll:float= -100
var ul:float= 100

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
