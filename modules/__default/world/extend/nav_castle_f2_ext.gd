extends SceneExtension

const sceneID="nav_castle_f2"

func on_enterScene():
	#parent_scene.set_bg(load("res://assets/images/bg/nav_beach_sun.png"))
	if (!Global.QS.is_quest_active(GR.getQuest("main_chapter1")) && !Global.QS.is_quest_completed(GR.getQuest("main_chapter1"))):
		Global.hud.say("TODO intro your new home.")
		Global.QS.start_quest(GR.getQuest("main_chapter1"))
		Global.QS.start_quest(GR.getQuest("find_locations1"))
		GR.setModuleFlag("Default","Chores_Duty",2)
		GR.setModuleFlag("Default","Chores_Todo",GR.getModuleFlag("Default","Chores_Duty"))
	else:
		Global.hud.say("You are in the Castle floor 2.")

func get_buttons(menuid:String,buttons:Array):
	if(menuid==""):
		buttons.push_back(Button_Config.new("go somewhere else...","",parent_scene.menu.bind("walk")))
		buttons.push_back(Button_Config.new("do chores","",parent_scene.menu.bind("chores")))
		buttons.push_back(Button_Config.new("explore","",parent_scene._on_bt_explore_pressed,parent_scene._requiresFatigue))
	if(menuid=="chores"):
		var chores=GR.getModuleFlag("Default","Chores_Todo",0) as int
		var duty=GR.getModuleFlag("Default","Chores_Duty",0) as int
		Global.hud.say("It is expected that you finish "+str(chores)+" more chores today.")
		if(chores<=0):
			Global.hud.say("You already did all your chores for today.")
		else:
			buttons.push_back(Button_Config.new("do chores","",parent_scene._on_bt_do_chores_pressed))
	if(menuid=="walk"):
		Global.hud.say("Where would you like to go?")
		buttons.push_back(Button_Config.new("your bedding","",parent_scene.navigate_home))
		if(GR.getModuleFlag("Default","Found_Library",0)>0):
			buttons.push_back(Button_Config.new("Library","",Global.main.runScene.bind("nav_castle_library")))
		
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
	Global.hud.addButton("Get up","",parent_scene.menu.bind(""))
