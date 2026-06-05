extends SceneExtension

const sceneID="dlg_pc_lutes"
var avatar_player
var avatar_lutes = load("res://assets/images/chars/lutes.png")
const NPC_Format = {"bgcolor":Color.DARK_ORANGE}

func on_enterScene():
	avatar_player = Global.pc.getBustImage()
	parent_scene.__displayImage(1,avatar_player)


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
		Global.hud.say("TODO...talking about harponing...")
		buttons.push_back(Button_Config.new("Next","",cb_menu("leave",true)))
	if(menuid=="requestTalk"):
		GR.increaseModuleFlag("Squishl","Lutes_Met",1)
		if(_met>5 && GR.getModuleFlag("Squishl","Lutes_Visitable",0)<1):
			Global.hud.say("You talk about this and that.")
			Global.hud.say("[Lutes is now available via menu]",Constants.GM_Format)
			GR.setModuleFlag("Squishl","Lutes_Visitable",1)
			buttons.push_back(Button_Config.new("Thats cool","",cb_menu("leave",true)))
		elif(_met>1 && GR.getModuleFlag("Squishl","Lutes_Love",0)<=0):
			Global.hud.say("Did you see that trinket on those rocks out in the sea? If you can get it for me, I would be grateful...",NPC_Format)
			buttons.push_back(Button_Config.new("Trinket?","",cb_menu("questTrinket",true)))
		else:
			#add bitmask to disable/unlock entrys	
			Global.hud.say("You have questions, I can see it in your face.",NPC_Format)
			var q=Global.QS.active.get_quest_from_id("lutes_kill_crab")
			if(q && q.get_first_uncompleted_step() && q.get_first_uncompleted_step().index==1):  # means PC was there and has item
				buttons.push_back(Button_Config.new("Mission done","",cb_menu("finishMission",true)))
			else:
				buttons.push_back(Button_Config.new("Mission please","",cb_menu("startMission",true)))
			buttons.push_back(Button_Config.new("Where is this place?","",cb_menu("askBeach",true)))
			buttons.push_back(Button_Config.new("There have to be other people around here.","",cb_menu("askInhabitants",true)))
			buttons.push_back(Button_Config.new("But whats behind the beach and that forest. Is there a settlement or something?","",cb_menu("askMap",true)))
			buttons.push_back(Button_Config.new("Are there fish to catch here?","",cb_menu("askFishing",true)))
			buttons.push_back(Button_Config.new("I guess I will leave now","",cb_menu("leave",true)))
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
		buttons.push_back(Button_Config.new("That sucks","All the effort for nothing?",cb_menu("leave",true)))
		if Global.QS.active.get_quest_from_id("lutes_trinket"):
			Log.error("quest should be complete")
	if(menuid=="startMission"):
		Global.hud.say("One cannot set foot on this beach without getting pinched by those pesky scissor-guys. Go and teach them a lesson.",NPC_Format)
		Global.QS.start_quest(GR.getQuest("lutes_kill_crab"))
		buttons.push_back(Button_Config.new("Sure","",cb_menu("leave",true)))
	if(menuid=="finishMission"):
		Global.npc_talked.emit("Lutes","talk_kill_crab")
		Global.hud.say("Well done, here is your prize.",NPC_Format)
		Global.hud.say("Oh my godness...another of those useless bottles. I am so excited.")
		Global.hud.say("Stuff it (throws the bottle at your head).",NPC_Format)
		Global.pc.inventory.addItem(GR.createItem("vial_empty"))
		GR.increaseModuleFlag("Squishl","Lutes_Love",1)
		buttons.push_back(Button_Config.new("I'm out","",cb_menu("leave",true)))
		
		if Global.QS.active.get_quest_from_id("lutes_trinket"):
			Log.error("quest should be complete")	
	if(menuid=="askBeach"):
		Global.hud.say("This is a beach, obviously...",NPC_Format)
		buttons.push_back(Button_Config.new("Next","",cb_menu("requestTalk",true)))
	if(menuid=="askFishing"):
		Global.hud.say("They will rather catch you....",NPC_Format)
		buttons.push_back(Button_Config.new("Next","",cb_menu("requestTalk",true)))
	if(menuid=="askInhabitants"):
		Global.hud.say("You mean people like you?... ",NPC_Format)
		buttons.push_back(Button_Config.new("Next","",cb_menu("requestTalk",true)))
	if(menuid=="askMap"):
		Global.hud.say("You mean a village of your ...kind? No, I never heard of that, but I'm mostly at the beach. ",NPC_Format)
		Global.hud.say("And you shouldnt walk careless in the forest, its easy to get lost there. And there are things lurking... ",NPC_Format)
		buttons.push_back(Button_Config.new("Next","",cb_menu("requestTalk",true)))
	if(menuid=="requestFuck_Nope"):
		Global.hud.say("No pressure....")
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
