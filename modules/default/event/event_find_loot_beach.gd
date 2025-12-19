extends EventBase
class_name EventFindLootBeach

# an event that gives the player some loot

func _init():
	super()
	id="EventFindLootBeach"

func react(_triggerID, _args)->bool:
	return false
	
func canRun()->bool:
	return true
