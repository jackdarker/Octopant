extends EventBase

func _init():
	super()
	ID="EventVisStat"

func react(_triggerID,_location,_args)->bool:
	var _bev=Global.pc.getStat(StatEnum.Fatigue).value_percent
	Global.main.runScene("vis_stat",[],Global.main.getCurrentScene().uniqueSceneID)
	GR.setModuleFlag("Default","FatigueHigh",_bev)
	return false
	
func canRun(_trigger,_location,_args)->bool:
	var _ret:=false
	var _bev=Global.pc.getStat(StatEnum.Fatigue).value_percent
	if(_bev>=80 && GR.getModuleFlag("Default","FatigueHigh",0)<80):
		Tutorials.tutorial_trigger.emit("basic_tired")
		_ret=true
	else:
		GR.setModuleFlag("Default","FatigueHigh",_bev)
	return _ret
