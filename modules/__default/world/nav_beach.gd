extends "res://ui/navigation_scene.gd"


func _init() -> void:
	sceneID="nav_beach"

func _on_bt_explore_pressed():
	Global.hud.clearInput()
	Global.main.doTimeProcess(30*60)
	Global.pc.getStat(StatEnum.Fatigue).modify(10)
	GR.increaseModuleFlag("Default","Explored_Beach",1)
	var explored=GR.getModuleFlag("Default","Explored_Beach",0)
	var cards=GR.getModuleFlag("Default","ExploreCards_Beach",0) as int
	var _rnd=(randi()%(cards+1)) # only sometimes...
	if(cards<=0 && explored>5):
		cards=1
		_rnd=1
		GR.setModuleFlag("Default","ExploreCards_Beach",cards)
		Global.hud.say("[b]You are more familiar with your surroundings and may now avoid stumbling randomly into some event.[/b]")
	elif(cards<=1 && explored>15):
		cards=2
		_rnd=1
		GR.setModuleFlag("Default","ExploreCards_Beach",cards)
		Global.hud.say("[b]You got even more familiar with your surroundings.[/b]")
	if(GR.getModuleFlag("Default","Beach_Shack",0)==0):
		navigate_home()	#force finding shack
	elif (cards>0 && _rnd>0):	#Todo add to other nav_...
		var _evts=Global.ES.pickEvents(EventSystem.TRIGGER.Explore,"nav_beach_explore",cards+1,[])
		if(_evts.size()>0):
			for _evt:EventBase in _evts:
				Global.hud.addButton(Util.pickRandomFromArray([_evt.EventName,"???"])  ,
					"",_evt.react.bind(EventSystem.TRIGGER.Explore).bind("nav_beach_explore").bind([]))
		else:
			Global.hud.say("After a while you find yourself back were you came from.")
			continueScene()
	elif !Global.ES.triggerEvent(EventSystem.TRIGGER.Explore,"nav_beach_explore",[]):
		Global.hud.say("After a while you find yourself back were you came from.")
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
