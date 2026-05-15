extends EventBase

func _init():
	super()
	ID="EventMeetLutesBeach"

func react(_triggerID,_location,_args)->bool:
	Global.main.runScene("interaction_scene",
		["dlg_pc_lutes",
		Global.main.getCurrentScene().get_bg()],
		Global.main.getCurrentScene().uniqueSceneID)
	return false
	
func canRun(_trigger,_location,_args)->bool:
	var _met:int=GR.getModuleFlag("Squishl","Lutes_Met",0)
	if Global.main.getDays()>1:
		return _met<=5	#menu unlocked
	return (false)
