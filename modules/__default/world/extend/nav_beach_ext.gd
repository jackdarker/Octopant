extends SceneExtension

const sceneID="nav_beach"

func on_enterScene():
	parent_scene.set_bg(load("res://assets/images/nav_beach_sun.png"))
	if (GR.getModuleFlag("Default","Found_Beach",0)<=0):
		Global.hud.say("I found myself at a beach.")
		GR.setModuleFlag("Default","Found_Beach",1)
	else:
		Global.hud.say("I found myself back at the beach.")

func get_buttons(menuid:String,buttons:Array):
	if(menuid==""):
		buttons.push_back(Button_Config.new("go somewhere else...","",parent_scene.menu.bind("walk")))
		buttons.push_back(Button_Config.new("explore","",parent_scene._on_bt_explore_pressed,parent_scene._requiresFatigue))
		buttons.push_back(Button_Config.new("search for...","",parent_scene._on_bt_explore_pressed,parent_scene._requiresFatigue))
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
