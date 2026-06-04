extends SceneExtension

const sceneID="nav_debug"

func on_enterScene():
	parent_scene.set_bg(load("res://assets/images/bg/nav_beach_sun.png"))
	Global.hud.say("This is the mysterious debug cell.")

func get_buttons(menuid:String,buttons:Array):
	if(menuid==""):
		buttons.push_back(Button_Config.new("go somewhere else...","",parent_scene.menu.bind("walk")))
		buttons.push_back(Button_Config.new("testfight","",parent_scene._on_bt_fight_pressed))
		buttons.push_back(Button_Config.new("bash head","",hurtYourself))
		buttons.push_back(Button_Config.new("pitty you","",pittyYourself))
		buttons.push_back(Button_Config.new("go crazy","",crazyYourself))
		buttons.push_back(Button_Config.new("strain you","",fatigueYourself))
	if(menuid=="walk"):
		Global.hud.say("Where would you like to go?")
		buttons.push_back(Button_Config.new("go home","",parent_scene.navigate_home))
	return(buttons)

func hurtYourself():
	Global.pc.getStat(StatEnum.Pain).modify(30)
	Global.main.doTimeProcess(5*60)
	GR.setModuleFlag("Default","FaintMessage","headbashing")
	parent_scene.continueScene()
	
func pittyYourself():
	Global.pc.getStat(StatEnum.Insanity).modify(-20)
	Global.main.doTimeProcess(5*60)
	parent_scene.continueScene()

func crazyYourself():
	Global.pc.getStat(StatEnum.Insanity).modify(20)
	Global.main.doTimeProcess(5*60)
	parent_scene.continueScene()

func fatigueYourself():
	Global.pc.getStat(StatEnum.Fatigue).modify(30)
	Global.main.doTimeProcess(5*60)
	parent_scene.continueScene()

func maySunbath(apply=false)->Result:
	var check:=CondCheck.new()
	check.addCond([CondCheck.Cond_Resource.create("seashell",1),
		CondCheck.Cond_StatChange.create(StatEnum.Fatigue,-10)])
	return	check.check(Global.pc,apply)

func sunbathing():
	maySunbath(true)
	Global.hud.clearInput()
	Global.hud.clearOutput()
	Global.hud.say("You lay down on the dry sand and expose yourself to the sun.")
	Global.main.doTimeProcess(30*60)
	Global.hud.addButton("Get up","",parent_scene.menu.bind(""))
