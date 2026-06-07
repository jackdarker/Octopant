extends SceneExtension

const sceneID="nav_beach"

func on_enterScene():
	parent_scene.set_bg(load("res://assets/images/bg/nav_beach_sun.png"))
	if (GR.getModuleFlag("Default","Found_Beach",0)<=0):
		Global.hud.say("You found yourself at a beach. If you would have any memory how you got here, you would be abel to appreciate it.")
		Global.hud.say("There seems to be no one around and none of the typical signs of civilsation - rubbish and prohibition signs - are visible.")
		Global.hud.say("Maybe you should check what is next to this sandy coast.")
		Global.QS.start_quest(GR.getQuest("find_locations1"))
		GR.setModuleFlag("Default","Found_Beach",1)
	else:
		Global.hud.say("Visiting the the beach again.")

func get_buttons(menuid:String,buttons:Array):
	if(menuid==""):
		if(GR.getModuleFlag("Default","Beach_Shack",0)!=0):
			buttons.push_back(Button_Config.new("go somewhere else...","",parent_scene.menu.bind("walk")))
		buttons.push_back(Button_Config.new("explore","",parent_scene._on_bt_explore_pressed,parent_scene._requiresFatigue))
		#TODO buttons.push_back(Button_Config.new("sunbathing","tan your body",sunbathing,maySunbath))
		buttons.push_back(Button_Config.new("testdungeon","",Global.main.runScene.bind("dng_tidal_cave",[],Global.main.getCurrentScene().uniqueSceneID)))
		buttons.push_back(Button_Config.new("talk to crab","",parent_scene._on_bt_crab_pressed))
	if(menuid=="walk"):
		Global.hud.say("Where would you like to go?")
		buttons.push_back(Button_Config.new("shack","",parent_scene.navigate_home))
		if(GR.getModuleFlag("Default","Found_Cliff",0)>0):
			buttons.push_back(Button_Config.new("Cliff","",Global.main.runScene.bind("nav_cliff")))
		if(GR.getModuleFlag("Default","Found_Forest",0)>0):
			buttons.push_back(Button_Config.new("Forest","",Global.main.runScene.bind("nav_forest")))
	
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
