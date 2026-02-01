extends "res://ui/navigation_scene.gd"

func _init() -> void:
	sceneID="nav_deepwood"

func enterScene():
	super()
	if (GlobalRegistry.getModuleFlag("Default","Found_DeepWoods",0)<=0):
		Global.hud.say("I found myself in a dense forest.")
		GlobalRegistry.increaseModuleFlag("Default","Found_DeepWoods",1)
	Global.hud.addButton("go somewhere else...","",_on_bt_walk_pressed)
	Global.hud.addButton("explore","",_on_bt_explore_pressed)
	Global.hud.addButton("search for...","",_on_bt_search_pressed)

func _on_bt_search_pressed():
	Global.hud.clearInput()
	Global.hud.say("What are you looking for?")
	Global.hud.addButton("back","",enterScene)
	Global.hud.addButton("anything","",_on_bt_explore_pressed)
	pass

func _on_bt_explore_pressed():
	Global.hud.clearInput()
	Global.main.doTimeProcess(30*60)
	GlobalRegistry.increaseModuleFlag("Default","Explored_DeepWoods",1)
	if !Global.ES.triggerEvent(EventSystem.TRIGGER.EnterRoom,"nav_deepwoods_explore",[]):
		Global.hud.say("Nothing was found")
		continueScene()

func _on_bt_walk_pressed():
	Global.hud.clearInput()
	Global.hud.say("Where would you like to go?")
	Global.hud.addButton("back","",enterScene)
	Global.hud.addButton("go home","",navigate_home)
	Global.hud.addButton("beach","",Global.main.runScene.bind("nav_beach"))
