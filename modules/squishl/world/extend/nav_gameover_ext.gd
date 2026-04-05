extends SceneExtension

const sceneID="nav_gameover"

func on_enterScene():
	var where=GR.getModuleFlag("Default","FaintMessage","")
	if(where=="headbashing"):
		Global.hud.clearOutput()
		Global.hud.say("You bash your head against a rock until it cracks.")
		Global.hud.say("\n\nLoad a save game or try a restart.")
