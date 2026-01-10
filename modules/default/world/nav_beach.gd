extends "res://ui/navigation_scene.gd"


func _init() -> void:
	sceneID="nav_beach"

func enterScene():
	super()
	if (GlobalRegistry.getModuleFlag("Default","Found_Beach",0)<=0):
		Global.ui.say("I found myself at a beach.")
		GlobalRegistry.increaseModuleFlag("Default","Found_Beach",1)
	Global.ui.addButton("go somewhere else...","",_on_bt_walk_pressed)
	Global.ui.addButton("explore","",_on_bt_explore_pressed,_requiresFatigue)
	Global.ui.addButton("search for...","",_on_bt_search_pressed,_requiresFatigue)
	Global.ui.addButton("talk to crab","",_on_bt_crab_pressed)
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
	Global.pc.getStat(StatEnum.Fatigue).modify(20)
	GlobalRegistry.increaseModuleFlag("Default","Explored_Beach",1)
	if !Global.ES.triggerEvent(EventSystem.TRIGGER.EnterRoom,"nav_beach_explore",[]):
		Global.ui.say("Nothing was found")
		continueScene()

func _on_bt_walk_pressed():
	Global.ui.clearInput()
	Global.ui.say("Where would you like to go?")
	Global.ui.addButton("back","",enterScene)
	Global.ui.addButton("go home","",navigate_home)
	if(GlobalRegistry.getModuleFlag("Default","Found_Cliff",0)>0):
		Global.ui.addButton("Cliff","",Global.main.runScene.bind("nav_cliff"))

func _on_bt_crab_pressed():
	Global.main.runScene("interaction_scene",
		[load("res://modules/default/interaction/dlg_pc_crab.gd"),
		$TextureRect.texture],self.uniqueSceneID)

func _requiresFatigue():
	var _res:Result=Result.create(true,"")
	var _fat=Global.pc.getStat(StatEnum.Fatigue)
	if((_fat.ul-_fat.value)<20):
		_res.OK=false
		_res.Msg="You are to tired for this."
	return _res
