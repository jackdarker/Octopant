extends EventBase
class_name EventFindPathDeepWoods

# an event that gives the player a path to location

func _init():
	super()
	ID="EventFindPathDeepWoods"

func react(_triggerID, _args)->bool:
	Global.main.runScene("nav_deepwood")
	Global.ui.say("As you might not be able to sustain forever just by rooming the beach, you convince yourself to set foot in the forest.\\n")
	return true
	
func canRun()->bool:
	if(GlobalRegistry.getModuleFlag("Default","Explored_Beach",0)>5):
		return true
	return false
