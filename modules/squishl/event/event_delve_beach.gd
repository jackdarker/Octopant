extends EventBase

# player has to go through number of events before returning to beach

func _init():
	super()
	ID="EventDelveBeach"

func react(_triggerID, _args)->bool:
	Global.hud.say("There is something shiny over there. But you would have to walk through the water and something might lurk below.")
	Global.hud.addButton("Ignore it","",_ignore,null)
	Global.hud.addButton("Walk into the water","",_moveOn,null)
	return true
	
func canRun()->bool:
	var _x=GR.getModuleFlag("Squishl","Daily_Treasure",0)
	return _x<1

func _ignore():
	Global.hud.say("\n")
	Global.main.getCurrentScene().continueScene()

func _moveOn():
	Global.hud.clearInput()
	GR.setModuleFlag("Squishl","Delve_State",0)
	Global.main.runScene("dng_beach",[],Global.main.getCurrentScene().uniqueSceneID)
