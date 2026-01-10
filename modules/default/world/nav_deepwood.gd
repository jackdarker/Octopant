extends "res://ui/navigation_scene.gd"

func _init() -> void:
	sceneID="nav_deepwood"

func enterScene():
	super()
	if (GlobalRegistry.getModuleFlag("Default","Found_DeepWoods",0)<=0):
		Global.ui.say("I found myself in a dense forest.")
		GlobalRegistry.increaseModuleFlag("Default","Found_DeepWoods",1)
	Global.ui.addButton("go somewhere else...","",_on_bt_walk_pressed)
	Global.ui.addButton("explore","",_on_bt_explore_pressed)
	Global.ui.addButton("search for...","",_on_bt_search_pressed)

func _on_bt_search_pressed():
	Global.ui.clearInput()
	Global.ui.say("What are you looking for?")
	Global.ui.addButton("back","",enterScene)
	Global.ui.addButton("anything","",_on_bt_explore_pressed)
	pass

func _on_bt_explore_pressed():
	Global.ui.clearInput()
	Global.main.doTimeProcess(30*60)
	GlobalRegistry.increaseModuleFlag("Default","Explored_DeepWoods",1)
	if !Global.ES.triggerEvent(EventSystem.TRIGGER.EnterRoom,"nav_deepwoods_explore",[]):
		Global.ui.say("Nothing was found")
		continueScene()

func _on_bt_walk_pressed():
	Global.ui.clearInput()
	Global.ui.say("Where would you like to go?")
	Global.ui.addButton("back","",enterScene)
	Global.ui.addButton("go home","",navigate_home)
	Global.ui.addButton("beach","",Global.main.runScene.bind("nav_beach"))
