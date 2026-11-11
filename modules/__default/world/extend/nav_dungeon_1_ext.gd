extends SceneExtension

const sceneID="nav_dungeon_1"
var style:int=0

func on_setupScene():
	style = randi() % 3

func on_enterScene():
	#parent_scene.set_bg(load("res://assets/images/bg/nav_beach_sun.png"))
	match(style):
		0: Global.hud.say("You make your way to a larger chamber and catch your breath for a moment. You're in the Chasms, the quiet, dark recesses furthest from the surface.")
		_: Global.hud.say("Some dungeon (floor 1).")

func get_buttons(menuid:String,buttons:Array):
	var _evtName:="nav_dungeon_1_explore"
	if(menuid==""):
		#buttons.push_back(Button_Config.new("go somewhere else...","",parent_scene.menu.bind("walk"))))
		var _evts=Global.ES.pickEvents(EventSystem.TRIGGER.Explore,_evtName,2,[])
		if(_evts.size()>0):
			for _evt:EventBase in _evts:
				buttons.push_back(Button_Config.new(Util.pickRandomFromArray([_evt.getName(),"???"]),
					"",_evt.react.bind(EventSystem.TRIGGER.Explore).bind(_evtName).bind([])))

		buttons.push_back(Button_Config.new("...","",parent_scene.menu.bind("other")))
		#buttons.push_back(Button_Config.new("explore","",parent_scene._on_bt_explore_pressed))
	if(menuid=="other"):
		Global.hud.say("What else could you do?")
		Global.hud.say("Also check your inventory.")
		buttons.push_back(Button_Config.new("Give up","",CombatSetup.defaultDefeat.bind(null)))
		if(GR.getModuleFlag("Default","Found_Library",0)>0):
			buttons.push_back(Button_Config.new("Library","",Global.main.runScene.bind("nav_castle_library")))
		
	return(buttons)
