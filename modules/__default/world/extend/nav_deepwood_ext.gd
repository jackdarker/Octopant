extends SceneExtension

const sceneID="nav_deepwood"

func on_enterScene():
	parent_scene.set_bg(load("res://assets/images/bg/nav_forest_sun.png"))
	if (GR.getModuleFlag("Default","Found_DeepWoods",0)<=0):
		Global.hud.say("Behind the beach begins a dense forest.")
		GR.setModuleFlag("Default","Found_DeepWoods",1)

func get_buttons(menuid:String,buttons:Array):
	if(menuid==""):
		buttons.push_back(Button_Config.new("go somewhere else...","",parent_scene.menu.bind("walk")))
		buttons.push_back(Button_Config.new("explore","",parent_scene._on_bt_explore_pressed,parent_scene._requiresFatigue))
	if(menuid=="walk"):
		Global.hud.say("Where would you like to go?")
		buttons.push_back(Button_Config.new("Beach","",Global.main.runScene.bind("nav_beach")))

	return(buttons)
