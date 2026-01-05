extends "res://ui/navigation_scene.gd"

func _init() -> void:
	sceneID="nav_home"

func enterScene():
	super()
	Global.ui.addButton("go somewhere else...","",_on_bt_walk_pressed)
	Global.ui.addButton("sleep until morning","",_on_bt_sleep_pressed)
	pass

func _on_bt_walk_pressed():
	Global.ui.clearInput()
	Global.ui.say("Where would you like to go?")
	Global.ui.addButton("back","",enterScene)
	Global.ui.addButton("Cliff","",Global.main.runScene.bind("nav_beach"))
	if(GlobalRegistry.getModuleFlag("DefaultModule","Found_Cliff",0)>0):
		Global.ui.addButton("Cliff","",Global.main.runScene.bind("nav_cliff"))


func _on_bt_sleep_pressed() -> void:
	Global.main.startNewDay()
	pass # Replace with function body.
