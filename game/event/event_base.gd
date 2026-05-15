class_name EventBase extends Node

var ID:String = "unknown"

func _init():
	pass

## asks the event if it is available (additionally to location-filter)
func canRun(_trigger,_location,_args)->bool:
	return true

## 
func getWeight()->float:
	return(1.0)

## executes the event; if it only executes silently (f.e. just changing a flag), it should return false
func react(_triggerID,_location,_args)->bool:
	return(false)
	
