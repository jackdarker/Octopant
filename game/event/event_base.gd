class_name EventBase extends Node

var ID:String = "unknown"
var EventName = "unknown"
func _init():
	if(EventName=="unknown"):
		EventName=ID
	pass

## asks the event if it is available (additionally to location-filter)
## [br] args unused
func canRun(_trigger,_location,_args)->bool:
	return true

## events can have different weight (default is 1.0) to influence how likely it is to be choosen. This is only queried if canRun passes
## [br]Imagine their are 4 events with 1.0 and one with 4.0, then there is a 50% chance to pull the lst event (4* 1.0 : 4.0)
## [br]Do not use large numbers to try to enforce the event unless the number is reduced on other occasions!
func getWeight()->float:
	return(1.0)

## executes the event; if it only executes silently (f.e. just changing a flag), it should return false
func react(_triggerID,_location,_args)->bool:
	return(false)
	
