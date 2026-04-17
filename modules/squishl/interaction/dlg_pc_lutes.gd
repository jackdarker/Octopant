extends SceneExtension

const sceneID="dlg_pc_lutes"
const avatar_player = "res://assets/images/icons/ic_unknown.svg"
const avatar_lutes = "res://assets/images/chars/lutes.png"

func on_enterScene():
	parent_scene.__displayImage(1,avatar_player)
	
	pass

func get_buttons(menuid:String,buttons:Array):
	var _met:bool=GR.getModuleFlag("Squishl","Lutes_Met",0)>0
	if(menuid==""):
		if(!_met):
			Global.hud.say("There is really someone else down at the beach. \n Should you try to talk to them?.")
			buttons.push_back(Button_Config.new("Better not","",cb_menu("runAway",true)))
			buttons.push_back(Button_Config.new("Sure","",cb_menu("introTalk1",true)))
		else:
			parent_scene.__displayImage(2,avatar_lutes)
			Global.hud.say("Hey, you again !")
			buttons.push_back(Button_Config.new("Oh hello. Can we talk?","",cb_menu("requestTalk",true)))
			buttons.push_back(Button_Config.new("Wanna fuck?.","",cb_menu("requestFuck",true),_may_ask_fuck))
			buttons.push_back(Button_Config.new("I am in a hurry..","",cb_menu("leave",true)))
	if(menuid=="introTalk1"):
		GR.setModuleFlag("Squishl","Lutes_Met",1)
		parent_scene.__displayImage(2,avatar_lutes)
		Global.hud.say("As you get closer to the person,...")
		buttons.push_back(Button_Config.new("Next","",cb_menu("introTalk2",true)))
	if(menuid=="introTalk2"):
		Global.hud.say("...talking about harponing...")
		buttons.push_back(Button_Config.new("Next","",cb_menu("leave",true)))
	if(menuid=="requestTalk"):
		GR.increaseModuleFlag("Squishl","Lutes_Met",1)
		Global.hud.say("You talk about this and that.")
		buttons.push_back(Button_Config.new("Next","",cb_menu("leave",true)))
	if(menuid=="requestFuck"):
		Global.hud.say("Sorry, not in the mood")
		buttons.push_back(Button_Config.new("Next","",cb_menu("requestFuck_Nope",true)))
	if(menuid=="requestFuck_Nope"):
		Global.hud.say("OK, no problem....")
		buttons.push_back(Button_Config.new("Next","",cb_menu("leave",true)))
	if(menuid=="leave"):
		Global.hud.say("I need to leave.")
		buttons.push_back(Button_Config.new("Leave","",Global.main.removeScene.bind(parent_scene)))
	if(menuid=="runAway"):
		Global.hud.say("You stay hidden until you sneaked out of sight.")
		buttons.push_back(Button_Config.new("Leave","",Global.main.removeScene.bind(parent_scene)))
	return(buttons)
	
func _may_ask_fuck()->Result:
	var _res:=Result.create(false,"dare you asking that")
	return _res
