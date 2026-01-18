extends EventBase
class_name EventNothing

# an event that gives the player some loot

func _init():
	super()
	ID="EventNothing"

func react(_triggerID, _args)->bool:
	return false
	
func canRun()->bool:
	return true
