extends "res://ui/navigation_scene.gd"

func _init() -> void:
	sceneID="nav_cliff"

func enterScene():
	super()
	if (GlobalRegistry.getModuleFlag("Default","Found_Cliff",0)<=0):
		Global.hud.say("Your walk at the beach finally brings you to a high cliff.")
		GlobalRegistry.increaseModuleFlag("Default","Found_Cliff",1)
	Global.hud.say("The cliff looks climbable even for your poor abilitys.")
	Global.hud.say("As long as you have some rope with you it should be safe enough.")
	
	Global.hud.addButton("go somewhere else...","",_on_bt_walk_pressed)
	#Global.hud.addButton("climb up","",_on_bt_climbup_pressed)
	#Global.hud.addButton("climb down","",_on_bt_climbdown_pressed)
	pass

func _on_bt_walk_pressed():
	Global.hud.clearInput()
	Global.hud.say("Where would you like to go?")
	Global.hud.addButton("back","",enterScene)
	Global.hud.addButton("go home","",navigate_home)
	Global.hud.addButton("Beach","",Global.main.runScene.bind("nav_beach"))
