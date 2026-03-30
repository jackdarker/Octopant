extends "res://ui/navigation_scene.gd"


func _init() -> void:
	sceneID="nav_beach"

func _on_bt_explore_pressed():
	Global.hud.clearInput()
	Global.main.doTimeProcess(30*60)
	Global.pc.getStat(StatEnum.Fatigue).modify(20)
	GR.increaseModuleFlag("Default","Explored_Beach",1)
	if !Global.ES.triggerEvent(EventSystem.TRIGGER.EnterRoom,"nav_beach_explore",[]):
		Global.hud.say("Nothing was found")
		continueScene()

func _on_bt_crab_pressed():
	Global.main.runScene("interaction_scene",
		[load("res://modules/__default/interaction/dlg_pc_crab.gd"),
		%bg_image.texture],self.uniqueSceneID)

func _on_bt_fight_pressed():
	var _setup=CombatSetup.new()
	var _x=Global.pc.effects.getItems()
	_setup.playerParty.push_back(Global.pc)
	_setup.enemyParty.push_back(GR.createCharacter("Crab"))
	Global.main.runScene("combat_scene",
		[_setup],self.uniqueSceneID)

func _requiresFatigue():
	var _res:Result=Result.create(true,"")
	var _fat=Global.pc.getStat(StatEnum.Fatigue)
	if((_fat.ul-_fat.value)<20):
		_res.OK=false
		_res.Msg="You are to tired for this."
	return _res
