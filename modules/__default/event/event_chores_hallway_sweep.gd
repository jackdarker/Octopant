extends EventBase

# 

func _init():
	ID="EventChoresHallwaySweep"
	super()
	

func react(_triggerID,_location,_args)->bool:
	Global.hud.clearInput()
	Global.main.runScene("interaction_scene",
		["evt_pc_servant",
		Global.main.getCurrentScene().get_bg()],
		Global.main.getCurrentScene().uniqueSceneID)
	return false
	
