class_name Status extends Node

# Character value

signal changed(ID:String,value:float)

static func create(_key,_data)->Status:
	var _n=Status.new()
	_n.key=_key
	_n.value=_data
	return _n

var key:String="UNKNOWN"
var value:float=0
var ll:float= -100
var ul:float= 100

func modify(change:float):
	value=min(ul,max(ll,value+change))
	changed.emit(key,value)

func loadData(data):
	key=data["key"]
	value=data["value"]		
	ll=data["ll"]
	ul=data["ul"]
			
func saveData()->Variant:
	return({"key":key,"value":value,"ll":ll,"ul":ul})
