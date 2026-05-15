extends EventBase

# an event that gives the player a path to location

func _init():
	super()
	ID="EventFindPathForest"

func react(_triggerID,_location,_args)->bool:
	Global.hud.say("As you might not be able to sustain forever just by rooming the beach, you convince yourself to set foot in the forest.\n")
	Global.hud.addButton("next","",Global.main.runScene.bind("nav_forest"))
	return true
	
func canRun(_trigger,_location,_args)->bool:
	if(GR.getModuleFlag("Default","Explored_Beach",0)>5 && GR.getModuleFlag("Default","Found_Forest",0)==0):
		return true
	return false
