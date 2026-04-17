extends EventBase

func _init():
	super()
	ID="EventMeetLutesBeach"

func react(_triggerID, _args)->bool:
	Global.main.runScene("interaction_scene",
		[load("res://modules/squishl/interaction/dlg_pc_lutes.gd"),
		Global.main.getCurrentScene().get_bg()],
		Global.main.getCurrentScene().uniqueSceneID)
	return false
	
func canRun()->bool:
	if Global.main.getDays()>5:
		return true
	# _met = (GR.getModuleFlag("Squishl","Lutes_Met",0)!=0)
	return (false)
