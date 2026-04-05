extends SceneExtension

const sceneID="nav_beach"

func on_enterScene():
	parent_scene.set_bg(load("res://assets/images/bg/nav_beach_sun.png"))
	if (GR.getModuleFlag("Default","Found_Beach",0)<=0):
		Global.hud.say("You found yourself at a beach.")
		GR.setModuleFlag("Default","Found_Beach",1)
		Global.QS.start_quest(GR.getQuest("craft_knife"))
		Global.QS.start_quest(GR.getQuest("find_locations1"))
	else:
		Global.hud.say("Visiting the the beach again.")

func get_buttons(menuid:String,buttons:Array):
	if(menuid==""):
		buttons.push_back(Button_Config.new("go somewhere else...","",parent_scene.menu.bind("walk")))
		buttons.push_back(Button_Config.new("explore","",parent_scene._on_bt_explore_pressed,parent_scene._requiresFatigue))
		buttons.push_back(Button_Config.new("sunbathing","tan your body",sunbathing,maySunbath))
		buttons.push_back(Button_Config.new("talk to crab","",parent_scene._on_bt_crab_pressed))
		buttons.push_back(Button_Config.new("testfight","",parent_scene._on_bt_fight_pressed))
	if(menuid=="walk"):
		Global.hud.say("Where would you like to go?")
		buttons.push_back(Button_Config.new("go home","",parent_scene.navigate_home))
		if(GR.getModuleFlag("Default","Found_Cliff",0)>0):
			buttons.push_back(Button_Config.new("Cliff","",Global.main.runScene.bind("nav_cliff")))
		if(GR.getModuleFlag("Default","Found_DeepWoods",0)>0):
			buttons.push_back(Button_Config.new("DeepWood","",Global.main.runScene.bind("nav_deepwood")))
	
	return(buttons)

func maySunbath(apply=false)->Result:
	var check:=CondCheck.new()
	check.addCond([CondCheck.Cond_Resource.create("seashell",1),
		CondCheck.Cond_StatChange.create(StatEnum.Fatigue,-10)])
	return	check.check(Global.pc,apply)

func sunbathing():
	maySunbath(true)
	Global.hud.clearInput()
	Global.hud.clearOutput()
	Global.hud.say("You lay down on the dry sand and expose yourself to the sun.")
	Global.main.doTimeProcess(30*60)
	Global.hud.addButton("Get up","",parent_scene.menu)
