extends EventBase
class_name EventFindPathDeepWoods

# an event that gives the player a path to location

func _init():
	super()
	ID="EventFindPathDeepWoods"

func react(_triggerID, _args)->bool:
	Global.hud.say("As you might not be able to sustain forever just by rooming the beach, you convince yourself to set foot in the forest.\\n")
	Global.hud.addButton("next","",Global.main.runScene.bind("nav_deepwood"))
	return true
	
func canRun()->bool:
	if(GR.getModuleFlag("Default","Explored_Beach",0)>5 && GR.getModuleFlag("Default","Found_DeepWoods",0)==0):
		return true
	return false
