extends "res://ui/navigation_scene.gd"

func _init() -> void:
	sceneID="nav_cliff"

func enterScene():
	super()
	if (GlobalRegistry.getModuleFlag("Default","Found_Cliff",0)<=0):
		Global.ui.say("Your walk at the beach finally brings you to a high cliff.")
		GlobalRegistry.increaseModuleFlag("Default","Found_Cliff",1)
	Global.ui.say("The cliff looks climbable even for your poor abilitys.")
	Global.ui.say("As long as you have some rope with you it should be safe enough.")
	
	Global.ui.addButton("go somewhere else...","",_on_bt_walk_pressed)
	#Global.ui.addButton("climb up","",_on_bt_climbup_pressed)
	#Global.ui.addButton("climb down","",_on_bt_climbdown_pressed)
	pass

func _on_bt_walk_pressed():
	Global.ui.clearInput()
	Global.ui.say("Where would you like to go?")
	Global.ui.addButton("back","",enterScene)
	Global.ui.addButton("go home","",navigate_home)
	Global.ui.addButton("Beach","",Global.main.runScene.bind("nav_beach"))
