extends "res://ui/navigation_scene.gd"


func _init() -> void:
	sceneID="nav_beach"

func enterScene():
	super()
	if (GlobalRegistry.getModuleFlag("Default","Found_Beach",0)<=0):
		Global.hud.say("I found myself at a beach.")
		GlobalRegistry.increaseModuleFlag("Default","Found_Beach",1)
	Global.hud.addButton("go somewhere else...","",_on_bt_walk_pressed)
	Global.hud.addButton("explore","",_on_bt_explore_pressed,_requiresFatigue)
	Global.hud.addButton("search for...","",_on_bt_search_pressed,_requiresFatigue)
	Global.hud.addButton("talk to crab","",_on_bt_crab_pressed)
	Global.hud.addButton("testfight","",_on_bt_fight_pressed)
	pass

func _on_bt_search_pressed():
	Global.hud.clearInput()
	Global.hud.say("What are you looking for?")
	Global.hud.addButton("back","",enterScene)
	Global.hud.addButton("anything","",_on_bt_explore_pressed)
	pass

func _on_bt_explore_pressed():
	Global.hud.clearInput()
	Global.main.doTimeProcess(30*60)
	Global.pc.getStat(StatEnum.Fatigue).modify(20)
	GlobalRegistry.increaseModuleFlag("Default","Explored_Beach",1)
	if !Global.ES.triggerEvent(EventSystem.TRIGGER.EnterRoom,"nav_beach_explore",[]):
		Global.hud.say("Nothing was found")
		continueScene()

func _on_bt_walk_pressed():
	Global.hud.clearInput()
	Global.hud.say("Where would you like to go?")
	Global.hud.addButton("back","",enterScene)
	Global.hud.addButton("go home","",navigate_home)
	if(GlobalRegistry.getModuleFlag("Default","Found_Cliff",0)>0):
		Global.hud.addButton("Cliff","",Global.main.runScene.bind("nav_cliff"))
	if(GlobalRegistry.getModuleFlag("Default","Found_DeepWoods",0)>0):
		Global.hud.addButton("DeepWood","",Global.main.runScene.bind("nav_deepwood"))

func _on_bt_crab_pressed():
	Global.main.runScene("interaction_scene",
		[load("res://modules/default/interaction/dlg_pc_crab.gd"),
		$TextureRect.texture],self.uniqueSceneID)

func _on_bt_fight_pressed():
	var _setup=CombatSetup.new()
	var _x=Global.pc.effects.getItems()
	_setup.playerParty.push_back(Global.pc)
	_setup.enemyParty.push_back(GlobalRegistry.createCharacter("Crab"))
	Global.main.runScene("combat_scene",
		[_setup],self.uniqueSceneID)

func _requiresFatigue():
	var _res:Result=Result.create(true,"")
	var _fat=Global.pc.getStat(StatEnum.Fatigue)
	if((_fat.ul-_fat.value)<20):
		_res.OK=false
		_res.Msg="You are to tired for this."
	return _res
