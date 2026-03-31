extends EventBase

# player has to go through number of events before returning to beach

func _init():
	super()
	ID="EventDelveBeach"

func react(_triggerID, _args)->bool:
	var state=GR.getModuleFlag("Squishl","Delve_State",0)
	#if(state==1):
	#	return false				#TODO this is broken
	#else:
	Global.hud.say("There is something shiny over there. But you would have to walk through the water and something might lurk below.")
	Global.hud.addButton("Ignore it","",_ignore,null)
	Global.hud.addButton("Walk into the water","",_moveOn,null)
	return true
	
func canRun()->bool:
	return true
	#return (GR.getModuleFlag("Squishl","Squishl_Saved",0)==0)

func _ignore():
	Global.hud.say("\n")
	Global.main.getCurrentScene().continueScene()

func _moveOn():
	Global.hud.clearInput()
	Global.main.runScene("interaction_scene",
		[load("res://modules/squishl/interaction/delve_beach.gd"),
		null],Global.main.getCurrentScene().uniqueSceneID)
