extends EventBase

func _init():
	ID="EventMeetLutesBeach"
	super()

func react(_triggerID,_location,_args)->bool:
	Global.hud.clearInput()
	Global.main.runScene("interaction_scene",
		["dlg_pc_lutes",
		Global.main.getCurrentScene().get_bg()],
		Global.main.getCurrentScene().uniqueSceneID)
	return false
	
func canRun(_trigger,_location,_args)->bool:
	var _met:bool=!(GR.getModuleFlag("Squishl","Lutes_Visitable",0)>0)
	if Global.main.getDays()>1:
		return _met	#menu unlocked
	return (false)
