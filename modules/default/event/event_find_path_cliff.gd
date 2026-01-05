extends EventBase
class_name EventFindPathCliff

# an event that gives the player a path to location

func _init():
	super()
	id="EventFindPathCliff"

func react(_triggerID, _args)->bool:
	GlobalRegistry.setModuleFlag("DefaultModule","Found_Cliff",1)
	Global.main.runScene("nav_cliff")
	Global.ui.say("This time you made your way all down the beach until you stand before a high cliff.\n")
	return true
	
func canRun()->bool:
	if(GlobalRegistry.getModuleFlag("DefaultModule","Explored_Beach",0)>5):
		return true
	return false
