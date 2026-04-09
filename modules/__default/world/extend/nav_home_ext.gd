extends SceneExtension

const sceneID="nav_home"

func on_enterScene():
	parent_scene.set_bg(load("res://assets/images/bg/nav_home_sun.png"))
	Global.hud.say("Thats your cabin at the beach.")

func get_buttons(menuid:String,buttons:Array):
	if(menuid==""):
		buttons.push_back(Button_Config.new("go somewhere else...","",parent_scene.menu.bind("walk")))
		buttons.push_back(Button_Config.new("craft...","",parent_scene._on_bt_craft_pressed))
		buttons.push_back(Button_Config.new("sleep until morning","",parent_scene._on_bt_sleep_pressed))
	if(menuid=="walk"):
		Global.hud.say("Where would you like to go?")
		if(GR.getModuleFlag("Default","Found_Beach",0)>0):
			buttons.push_back(Button_Config.new("Beach","",Global.main.runScene.bind("nav_beach")))
			
	return(buttons)
