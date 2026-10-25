extends "res://ui/navigation_scene.gd"


func _init() -> void:
	sceneID="nav_dungeon_1"

func _on_bt_explore_pressed():
	Global.hud.clearInput()
	var _evtName:="nav_dungeon_1_explore"
	GR.increaseModuleFlag("Default","Explored_Dungeon_1",1)
	var explored=GR.getModuleFlag("Default","Explored_Dungeon_1",0)
	var cards=GR.getModuleFlag("Default","ExploreCards_Dungeon_1",0) as int
	var _rnd=(randi()%(cards+1)) # only sometimes...
	if(cards<=0 && explored>5):
		cards=1
		_rnd=1
		GR.setModuleFlag("Default","ExploreCards_Dungeon_1",cards)
		Global.hud.say("[b]You are more familiar with your surroundings and may now avoid stumbling randomly into some event.[/b]")
	elif(cards<=1 && explored>15):
		cards=2
		_rnd=1
		GR.setModuleFlag("Default","ExploreCards_Dungeon_1",cards)
		Global.hud.say("[b]You got even more familiar with your surroundings.[/b]")
	elif (cards>0 && _rnd>0):	#Todo add to other nav_...
		var _evts=Global.ES.pickEvents(EventSystem.TRIGGER.Explore,_evtName,cards+1,[])
		if(_evts.size()>0):
			for _evt:EventBase in _evts:
				Global.hud.addButton(Util.pickRandomFromArray([_evt.getName(),"???"])  ,
					"",_evt.react.bind(EventSystem.TRIGGER.Explore).bind(_evtName).bind([]))
		else:
			Global.hud.say("After a while you find yourself back were you came from.")
			continueScene()
	elif !Global.ES.triggerEvent(EventSystem.TRIGGER.Explore,_evtName,[]):
		Global.hud.say("After a while you find yourself back were you came from.")
		continueScene()
