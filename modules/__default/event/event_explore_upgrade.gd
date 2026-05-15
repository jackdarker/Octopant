extends EventBase

# triggers if explored enough and unlocks fatigue bonus for further exploring

func _init():
	super()
	ID="EventExploreUpgrade"

func react(_triggerID,_location,_args)->bool:
	if(_location=="nav_beach"):
		GR.increaseModuleFlag("Default","FatigueFactor_Beach",0.2)
		Global.hud.say("Your past exlorations of the beach improves your navigation")
	if(_location=="nav_forest"):
		GR.increaseModuleFlag("Default","FatigueFactor_Forest",0.2)
		Global.hud.say("Your past exlorations of the forest improves your navigation")
	Global.hud.say("Fatigue cost reduced",Constants.GM_Format)
	Global.main.getCurrentScene().continueScene()
	return true
	
func canRun(_trigger,_location,_args)->bool:
	if(_location=="nav_beach"):
		var _c=GR.getModuleFlag("Default","Explored_Beach",0)
		var _x=GR.getModuleFlag("Default","FatigueFactor_Beach",0)
		if(_c>5 && 0<=_x && _x<0.2):
			return true
	if(_location=="nav_forest"):
		var _c=GR.getModuleFlag("Default","Explored_Forest",0)
		var _x=GR.getModuleFlag("Default","FatigueFactor_Forest",0)
		if(_c>5 && 0<=_x && _x<0.2):
			return true
	return false
