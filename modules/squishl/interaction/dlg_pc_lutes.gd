extends SceneExtension

const sceneID="dlg_pc_lutes"
const avatar_player = "res://assets/images/icons/ic_unknown.svg"
const avatar_lutes = "res://assets/images/chars/lutes.png"
const NPC_Format = {"bgcolor":Color.DARK_ORANGE}

func on_enterScene():
	parent_scene.__displayImage(1,avatar_player)
	
	pass

func get_buttons(menuid:String,buttons:Array):
	var _met:int=GR.getModuleFlag("Squishl","Lutes_Met",0)
	if(menuid==""):
		if(_met==0):
			Global.hud.say("There is really someone else down at the beach. \n Should you try to talk to them?.")
			buttons.push_back(Button_Config.new("Better not","",cb_menu("runAway",true)))
			buttons.push_back(Button_Config.new("Sure","",cb_menu("introTalk1",true)))
		else:
			parent_scene.__displayImage(2,avatar_lutes)
			Global.hud.say("Hey, you again !",NPC_Format)
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
		if(_met>1 && GR.getModuleFlag("Squishl","Lutes_Love",0)<=0):
				Global.hud.say("Did you see that trinket on those rocks out in the sea? If you can get it for me, I would be grateful...",NPC_Format)
				buttons.push_back(Button_Config.new("Trinket?","",cb_menu("questTrinket",true)))
		else:	
			Global.hud.say("You talk about this and that.")
			buttons.push_back(Button_Config.new("Next","",cb_menu("leave",true)))
	if(menuid=="questTrinket"):
		var q=Global.QS.active.get_quest_from_id("lutes_trinket")
		if(q):
			var _qs=q.get_first_uncompleted_step()
			if _qs.index==2:   # means PC was there and has item
				Global.hud.say("You remember that you have the item that Lutes asked for.")
				buttons.push_back(Button_Config.new("I got this","",cb_menu("questTrinketSolve",true)))
			buttons.push_back(Button_Config.new("I'm not done yet","",cb_menu("leave",true)))
		elif Global.pc.inventory.hasItemID("vial_empty")>0:
			Global.hud.say("I already was there, there was just one of those vials.")
			Global.hud.say("Well, that can be true...or not. I'm just asking you to go there.",NPC_Format)
			Global.QS.start_quest(GR.getQuest("lutes_trinket"))
			buttons.push_back(Button_Config.new("Next","",cb_menu("leave",true)))
		else:
			Global.hud.say("Rocks in the sea? Sure I can take a look at it...")
			Global.QS.start_quest(GR.getQuest("lutes_trinket"))
			buttons.push_back(Button_Config.new("Next","",cb_menu("leave",true)))
	if(menuid=="questTrinketSolve"):
		Global.main.item_trade.emit(Global.pc.uniqueID,"Lutes","vial_empty",1)
		Global.hud.say("Its just some glass-vial, you know.")
		Global.hud.say("Thats fine, I just wanted to see if you would do it.",NPC_Format)
		Global.hud.say("Keep it, I dont need it.",NPC_Format)
		GR.increaseModuleFlag("Squishl","Lutes_Love",1)
		buttons.push_back(Button_Config.new("Sure","",cb_menu("leave",true)))
		buttons.push_back(Button_Config.new("That sucks","",cb_menu("leave",true)))
		if Global.QS.active.get_quest_from_id("lutes_trinket"):
			Log.error("quest should be complete")
	if(menuid=="requestFuck"):
		Global.hud.say("Sorry, not in the mood",NPC_Format)
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
