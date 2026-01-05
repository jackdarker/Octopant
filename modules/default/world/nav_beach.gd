extends "res://ui/navigation_scene.gd"


const States = {IDLE=1,DIGGING = 2, DIG_FAILED=3, DIG_SUCCESS=4 }

func _init() -> void:
	sceneID="nav_beach"

func enterScene():
	super()
	if (GlobalRegistry.getModuleFlag("Default","Found_Beach",0)<=0):
		Global.ui.say("I found myself at a beach.")
		GlobalRegistry.increaseModuleFlag("Default","Found_Beach",1)
	Global.ui.addButton("go somewhere else...","",_on_bt_walk_pressed)
	Global.ui.addButton("explore","",_on_bt_explore_pressed)
	Global.ui.addButton("search for...","",_on_bt_search_pressed)
	pass

func _on_bt_search_pressed():
	Global.ui.clearInput()
	Global.ui.say("What are you looking for?")
	Global.ui.addButton("back","",enterScene)
	Global.ui.addButton("anything","",_on_bt_explore_pressed)
	pass

func _on_bt_explore_pressed():
	Global.ui.clearInput()
	Global.main.doTimeProcess(30*60)
	GlobalRegistry.increaseModuleFlag("Default","Explored_Beach",1)
	if !Global.ES.triggerEvent(EventSystem.TRIGGER.EnterRoom,"nav_beach_explore",[]):
		Global.ui.say("Nothing was found")
		continueScene()
	#state=States.DIGGING
	#msg.text= "There is something sparkling between seasshells"
	#msg.config_bt(0,"Ignore it")
	#msg.config_bt(1,"Dig it out")
	#show_msg()

func _on_bt_walk_pressed():
	Global.ui.clearInput()
	Global.ui.say("Where would you like to go?")
	Global.ui.addButton("back","",enterScene)
	Global.ui.addButton("go home","",navigate_home)
	if(GlobalRegistry.getModuleFlag("Default","Found_Cliff",0)>0):
		Global.ui.addButton("Cliff","",Global.main.runScene.bind("nav_cliff"))



	
