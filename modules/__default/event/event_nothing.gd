extends EventBase

func _init():
	super()
	ID="EventNothing"

func react(_triggerID,_location,_args)->bool:
	return false
	
func canRun(_trigger,_location,_args)->bool:
	return true
