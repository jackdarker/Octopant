extends "res://ui/navigation_scene.gd"


func _init() -> void:
	sceneID="nav_beach"

func _on_bt_explore_pressed():
	Global.hud.clearInput()
	Global.main.doTimeProcess(30*60)
	Global.pc.getStat(StatEnum.Fatigue).modify(10)
	GR.increaseModuleFlag("Default","Explored_Beach",1)
	if(GR.getModuleFlag("Default","Beach_Shack",0)==0):
		navigate_home()	#force finding shack
	elif !Global.ES.triggerEvent(EventSystem.TRIGGER.EnterRoom,"nav_beach_explore",[]):
		Global.hud.say("Nothing was found")
		continueScene()

func _on_bt_crab_pressed():
	var x:Image=%bg_image.texture.get_image()
	x.resize_to_po2()
	var y:ImageTexture = ImageTexture.create_from_image(x)
	Global.main.runScene("interaction_scene",["dlg_pc_crab",
		#[load("res://modules/__default/interaction/dlg_pc_crab.gd"),
		y],self.uniqueSceneID)

func _on_bt_fight_pressed():
	var _setup=CombatSetup.new()
	var _x=Global.pc.effects.getItems()
	_setup.playerParty.push_back(Global.pc)
	var _i:=0
	for _mob in [GR.createCharacter("Crab"),GR.createCharacter("Crab")]:
		_i=_i+1
		_mob.uniqueID=_mob.ID+"#"+str(_i)
		_setup.enemyParty.push_back(_mob)
	Global.main.runScene("combat_scene",
		[_setup],self.uniqueSceneID)

func _requiresFatigue():
	var _res:Result=Result.create(true,"")
	var _fat=Global.pc.getStat(StatEnum.Fatigue)
	if((_fat.ul-_fat.value)<10):
		_res.OK=false
		_res.Msg="You are to tired for this."
	return _res
