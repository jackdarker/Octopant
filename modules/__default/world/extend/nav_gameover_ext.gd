extends SceneExtension

const sceneID="nav_gameover"

func on_enterScene():
	parent_scene.set_bg(load("res://assets/images/bg/paper1.png"))
	Global.hud.say("You journey ends here.")
	Global.hud.say("\n\nLoad a save game or try a restart.")

func get_buttons(menuid:String,buttons:Array):
	if(menuid==""):
		buttons.push_back(Button_Config.new("Restart","",Global.goto_scene.bind("res://ui/main_menu.tscn")))
	return(buttons)
