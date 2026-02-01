extends EventBase
class_name EventFindPathCliff

# an event that gives the player a path to location

func _init():
	super()
	ID="EventFindPathCliff"

func react(_triggerID, _args)->bool:
	Global.main.runScene("nav_cliff")
	Global.hud.say("This time you made your way all down the beach until you stand before a high cliff.\n")
	return true
	
func canRun()->bool:
	if(GlobalRegistry.getModuleFlag("Default","Explored_Beach",0)>5):
		return true
	return false
