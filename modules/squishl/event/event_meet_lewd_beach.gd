extends EventBase

func _init():
	ID="EventMeetLewdBeach"
	super()

func react(_triggerID,_location,_args)->bool:
	Global.main.runScene("interaction_scene",
		["dlg_pc_lewdsand",
		Global.main.getCurrentScene().get_bg()],
		Global.main.getCurrentScene().uniqueSceneID)
	return false
	
func canRun(_trigger,_location,_args)->bool:
	return true#(GR.getModuleFlag("Squishl","Squishl_Saved",0)>0)
