extends SceneExtension

const sceneID="nav_beach"

func on_enterScene():
	if(GR.getModuleFlag("Squishl","Lutes_Met",0)>=5):
		Global.hud.say("Lutes is also here.")

func get_buttons(menuid:String,buttons:Array):
	if(menuid==""):
		if(GR.getModuleFlag("Squishl","Lutes_Visitable",0)>0):
			buttons.push_back(Button_Config.new("visit lutes","",dlg_lutes,_can_meet_lutes))
	return(buttons)

func dlg_lutes():
	Global.main.runScene("interaction_scene",
		["dlg_pc_lutes",
		Global.main.getCurrentScene().get_bg()],
		Global.main.getCurrentScene().uniqueSceneID)

func _can_meet_lutes(_apply:bool=false):
	var _res:Result=Result.create(true,"Lutes is around")
	return _res
