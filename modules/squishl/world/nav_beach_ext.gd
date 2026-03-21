extends SceneExtension

func get_buttons(menuid:String,buttons:Array):
	if(menuid=="walk"):
		buttons.push_back(Button_Config.new("visit Squishl","",parent_scene.navigate_home))
	return(buttons)

func navigate_squishl():
	Global.main.runScene("nav_squisl")
