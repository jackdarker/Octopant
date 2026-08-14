extends SceneExtension

const sceneID="dlg_pc_lewdsand"

var form:int=0

func on_enterScene():
	parent_scene.set_bg(load("res://assets/images/bg/beach_sand.png"))

func get_buttons(menuid:String,buttons:Array):
	form=randi() % 4
	if(menuid==""):
		Global.hud.clearOutput()
		Global.hud.say("As your eyes scan the beach, they linger on a random shape that the waves may have formed...")
		buttons.push_back(Button_Config.new("Its just some sand...","",Global.main.removeScene.bind(parent_scene),null))
		buttons.push_back(Button_Config.new("Looks like someones backside","",cb_menu("backside",true),null))
	if(menuid=="leave"):
		Global.hud.say("I need to leave.")
		buttons.push_back(Button_Config.new("Leave","",Global.main.removeScene.bind(parent_scene)))
	if(menuid=="backside"):
		Global.hud.say("This really looks like someones bubble butt.")
		Global.hud.say("Naughty thoughts appear in your head...")
		Global.pc.getStat(StatEnum.Lust).modify(10,{"ul":60})
		Global.toolTip.showNotification("lust++", "arousal increase")	#Todo autom. tooltip if hud is hidden?
		buttons.push_back(Button_Config.new("Leave","",Global.main.removeScene.bind(parent_scene)))
	return(buttons)
