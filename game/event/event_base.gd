extends Node
class_name EventBase

var ID:String = "unknown"

func _init():
	pass

# asks the event if it is available (additionally to location-filter)
func canRun()->bool:
	return true

# executes the event; if it only executes silently (f.e. just changing a flag), it should return false
func react(_triggerID, _args)->bool:
	return(false)
	
