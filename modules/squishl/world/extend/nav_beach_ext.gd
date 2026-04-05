extends SceneExtension

const sceneID="nav_beach"

func on_enterScene():
	Global.hud.say("Lutes is also here.")


func get_buttons(menuid:String,buttons:Array):
	if(menuid==""):
		buttons.push_back(Button_Config.new("bash head","",hurtYourself))
		buttons.push_back(Button_Config.new("pitty you","",pittyYourself))
		buttons.push_back(Button_Config.new("go crazy","",crazyYourself))
		buttons.push_back(Button_Config.new("strain you","",fatigueYourself))
	elif(menuid=="walk"):
		buttons.push_back(Button_Config.new("visit lutes","",dlg_lutes))
	return(buttons)

func dlg_lutes():
	Global.main.runScene("interaction_scene",
		[load("res://modules/squishl/interaction/dlg_pc_lutes.gd"),
		Global.main.getCurrentScene().get_bg()],
		Global.main.getCurrentScene().uniqueSceneID)

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
