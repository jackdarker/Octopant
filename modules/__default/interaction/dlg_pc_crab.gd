extends SceneExtension

const sceneID="dlg_pc_crab"
const avatar_player = "res://assets/images/icons/ic_unknown.svg"
const avatar_crab = "res://assets/images/chars/spider1.svg"

func on_enterScene():
	parent_scene.__displayImage(1,avatar_player)
	parent_scene.__displayImage(2,avatar_crab)
	pass

func get_buttons(menuid:String,buttons:Array):
	if(menuid==""):
		Global.hud.say("And who are you?")
		buttons.push_back(Button_Config.new("Next","",cb_menu("answer1",true)))
	if(menuid=="answer1"):
		Global.hud.say("Iam a crab !")
		Global.hud.say("i need your help !")
		buttons.push_back(Button_Config.new("Sure","",cb_menu("help1",true),__hasSeashell))
		buttons.push_back(Button_Config.new("Nope","",cb_menu("nohelp1")))
	if(menuid=="help1"):
		Global.hud.say("I need seashell")
		buttons.push_back(Button_Config.new("Here you go","",cb_menu("help2",true)))
		buttons.push_back(Button_Config.new("I dont have one","",cb_menu("nohelp1",true)))
	if(menuid=="help2"):
		Global.hud.say("Thank you so much. Here let me give you this./n
		It squirts some green slime in front of you.")
		__hasSeashell(true)
		Global.pc.inventory.addItemID("gel_green")
		buttons.push_back(Button_Config.new("Thats nasty","",cb_menu("leave",true)))
	if(menuid=="nohelp1"):
		Global.hud.say("But I need seashell!")
		buttons.push_back(Button_Config.new("I have to leave","",cb_menu("leave",true)))
	if(menuid=="leave"):
		Global.hud.say("I need to leave.")
		buttons.push_back(Button_Config.new("Leave","",Global.main.removeScene.bind(parent_scene)))
	return(buttons)

func __hasSeashell(apply:bool=false):
	var check:=CondCheck.new()
	check.addCond([CondCheck.Cond_Resource.create("seashell",1)])
	return	check.check(Global.pc,apply)
