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
		Global.hud.addButton("Its just some sand...","",Global.main.removeScene.bind(parent_scene),null)
		Global.hud.addButton("Looks like someones backside","",cb_menu("backside",true),null)
	if(menuid=="leave"):
		Global.hud.say("I need to leave.")
		buttons.push_back(Button_Config.new("Leave","",Global.main.removeScene.bind(parent_scene)))
	if(menuid=="backside"):
		Global.hud.say("This really looks like someones bubble butt.")
		Global.hud.say("Naughty thoughts appear in your head...")
		Global.pc.getStat(StatEnum.Lust).modify(10,{"ul":60})
		buttons.push_back(Button_Config.new("Leave","",Global.main.removeScene.bind(parent_scene)))
	return(buttons)
