extends SceneExtension

const sceneID="nav_beach"

func on_enterScene():
	Global.hud.say("Squishl is also here.")


func get_buttons(menuid:String,buttons:Array):
	if(menuid=="walk"):
		buttons.push_back(Button_Config.new("visit Squishl","",navigate_squishl))
	return(buttons)

func navigate_squishl():
	Global.main.runScene("nav_squishl")
