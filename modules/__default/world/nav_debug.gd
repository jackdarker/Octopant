extends "res://ui/navigation_scene.gd"


func _init() -> void:
	sceneID="nav_debug"

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
