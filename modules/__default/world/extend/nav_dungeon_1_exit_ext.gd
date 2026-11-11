extends SceneExtension

const sceneID="nav_dungeon_1_exit"

func on_enterScene():
	parent_scene.set_bg(load("res://assets/images/bg/paper1.png"))
	var SP=GR.getModuleFlag("Default","SP_EarnedRun",0)
	var bossKilled=GR.getModuleFlag("Default","BossKilled",0)
	var rooms=GR.getModuleFlag("Default","RoomsExplored",0)
	var exit=GR.getModuleFlag("Default","ExitFound",0)
	if(SP==0): #dont calculate twice
		if(bossKilled):
			SP+=1
		if(exit>=1):
			SP+=1
		SP+=floor(rooms/5)
		GR.setModuleFlag("Default","SP_EarnedRun",SP)
		GR.increaseModuleFlag("Default","SP_EarnedTotal",SP)
		GR.increaseModuleFlag("Default","SP_Unspent",SP)
	Global.hud.say("explored rooms: "+str(rooms))
	Global.hud.say("defeated boss: "+str(bossKilled))
	if(exit>=255):
		Global.hud.say("made it out alive")
	elif(exit>=1):
		Global.hud.say("found the exit")
	Global.hud.say("earned skill points: "+str(SP))
	Global.hud.say("\n\nLoad a save game or try a restart.")

func get_buttons(menuid:String,buttons:Array):
	if(menuid==""):
		buttons.push_back(Button_Config.new("Continue Anyway","",Global.main.defaultDefeat.bind(self.parent_scene)))
	return(buttons)
