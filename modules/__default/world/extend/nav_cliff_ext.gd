extends SceneExtension

const sceneID="nav_cliff"

func on_enterScene():
	parent_scene.set_bg(load("res://assets/images/bg/nav_cliff_sun.png"))
	if (GR.getModuleFlag("Default","Found_Cliff",0)<=0):
		Global.hud.say("Your walk at the beach finally brings you to a high cliff.")
		GR.setModuleFlag("Default","Found_Cliff",1)
	Global.hud.say("The cliff looks climbable even for your poor abilitys.")
	Global.hud.say("As long as you have some rope with you it should be safe enough.")
	
func get_buttons(menuid:String,buttons:Array):
	if(menuid==""):
		buttons.push_back(Button_Config.new("go somewhere else...","",parent_scene.menu.bind("walk")))
		buttons.push_back(Button_Config.new("explore","",parent_scene._on_bt_explore_pressed,parent_scene._requiresFatigue))
	if(menuid=="walk"):
		Global.hud.say("Where would you like to go?")
		buttons.push_back(Button_Config.new("Beach","",Global.main.runScene.bind("nav_beach")))

	return(buttons)
