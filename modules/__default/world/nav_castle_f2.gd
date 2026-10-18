extends "res://ui/navigation_scene.gd"


func _init() -> void:
	sceneID="nav_castle_f2"


func _on_bt_explore_pressed():
	Global.hud.clearInput()
	Global.main.doTimeProcess(30*60)
	Global.pc.getStat(StatEnum.Fatigue).modify(10)
	GR.increaseModuleFlag("Default","Explored_Castle_F2",1)
	var explored=GR.getModuleFlag("Default","Explored_Castle_F2",0)
	var cards=GR.getModuleFlag("Default","ExploreCards_Castle_F2",0) as int
	var _rnd=(randi()%(cards+1)) # only sometimes...
	if(cards<=0 && explored>5):
		cards=1
		_rnd=1
		GR.setModuleFlag("Default","ExploreCards_Castle_F2",cards)
		Global.hud.say("[b]You are more familiar with your surroundings and may now avoid stumbling randomly into some event.[/b]")
	elif(cards<=1 && explored>15):
		cards=2
		_rnd=1
		GR.setModuleFlag("Default","ExploreCards_Castle_F2",cards)
		Global.hud.say("[b]You got even more familiar with your surroundings.[/b]")
	elif (cards>0 && _rnd>0):	#Todo add to other nav_...
		var _evts=Global.ES.pickEvents(EventSystem.TRIGGER.Explore,"nav_castle_f2_explore",cards+1,[])
		if(_evts.size()>0):
			for _evt:EventBase in _evts:
				Global.hud.addButton(Util.pickRandomFromArray([_evt.EventName,"???"])  ,
					"",_evt.react.bind(EventSystem.TRIGGER.Explore).bind("nav_castle_f2_explore").bind([]))
		else:
			Global.hud.say("After a while you find yourself back were you came from.")
			continueScene()
	elif !Global.ES.triggerEvent(EventSystem.TRIGGER.Explore,"nav_castle_f2_explore",[]):
		Global.hud.say("After a while you find yourself back were you came from.")
		continueScene()

func _on_bt_do_chores_pressed():
	Global.hud.clearInput()
	Global.main.doTimeProcess(30*60)
	var chores=GR.getModuleFlag("Default","Chores_Todo",0) as int
	if !Global.ES.triggerEvent(EventSystem.TRIGGER.Chores,"nav_castle_f2",[]):
		Global.hud.say("After a while you find yourself back were you came from.")
		continueScene()

func _requiresFatigue():
	var _res:Result=Result.create(true,"")
	var _fat=Global.pc.getStat(StatEnum.Fatigue)
	if((_fat.ul-_fat.value)<10):
		_res.OK=false
		_res.Msg="You are to tired for this."
	return _res
