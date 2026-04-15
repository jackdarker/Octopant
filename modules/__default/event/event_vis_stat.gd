extends EventBase

func _init():
	super()
	ID="EventVisStat"

func react(_triggerID, _args)->bool:
	var _bev=Global.pc.getStat(StatEnum.Fatigue).value_percent
	Global.main.runScene("vis_stat",[],Global.main.getCurrentScene().uniqueSceneID)
	GR.setModuleFlag("Default","FatigueHigh",_bev)
	return false
	
func canRun()->bool:
	var _ret:=false
	var _bev=Global.pc.getStat(StatEnum.Fatigue).value_percent
	if(_bev>=50 && GR.getModuleFlag("Default","FatigueHigh",0)<50):
		_ret=true
	else:
		GR.setModuleFlag("Default","FatigueHigh",_bev)
	return _ret
