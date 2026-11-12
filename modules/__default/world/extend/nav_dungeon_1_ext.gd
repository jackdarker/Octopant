extends SceneExtension

const sceneID="nav_dungeon_1"
var style:int=0

func on_setupScene():
	pass
	

func resetLevel():
	style = randi() % 3
	# x floors with some rooms
	var Rooms:={"A1":0,"A2":0,"A3":0,"A4":0,"A5":0,
		"B1":0,"B2":0,"B3":0,"B4":0,"B5":0,
		"C1":0,"C2":0,"C3":0,"C4":0,"C5":0,
		"D1":0,"D2":0,"D3":0,"D4":0,"D5":0,}
	# distribute items
	var _items:=["shirt_plain","shorts_plain"]
	var Items:={}
	var _rooms=Rooms.keys()
	for _item in _items:
		Items[Util.pickRandomFromArray(_rooms)]=_item
	Rooms[Util.pickRandomFromArray(["B4","D5"])]=10	#room with lever
	Rooms[Util.pickRandomFromArray(["A4","C3"])]=254#room with exit
	GR.setFlag("Default.Dungeon_Rooms",Rooms)
	GR.setFlag("Default.Dungeon_Items",Items)
	GR.setFlag("Default.Dungeon_Room","A1")	# start-room

func on_enterScene():
	if(GR.getFlag("Default.Dungeon_Room","")==""): #see start_run
		resetLevel()
	var _room=GR.getFlag("Default.Dungeon_Room","")
	var _target=GR.getFlag("Default.Dungeon_TargetRoom","")
	if(_room!=_target && _target!=""):
		var _explored:Dictionary = GR.getFlag("Default.Dungeon_RoomsExplored",{})
		_explored[_target]=1
		GR.setFlag("Default.Dungeon_RoomsExplored",_explored)
		Global.hud.say("Moving from "+_room+" to "+_target)
		GR.setFlag("Default.Dungeon_Room",_target)
		
	match(style):
		0: Global.hud.say("You make your way to a larger chamber and catch your breath for a moment. You're in the Chasms, the quiet, dark recesses furthest from the surface.")
		_: Global.hud.say("Some dungeon (floor 1).")

func get_buttons(menuid:String,buttons:Array):
	var _evtName:="nav_dungeon_1_explore"
	var _room:String=GR.getFlag("Default.Dungeon_Room","")
	var _floor:String=_room.substr(0,1)
	var _items:Dictionary=GR.getFlag("Default.Dungeon_Items",{})
	var _explored:Array = GR.getFlag("Default.Dungeon_RoomsExplored",{}).keys()
	_explored=_explored.filter(func(x):x.substr(0,1)==_floor)
	if(menuid==""):
		printRoomDesc(_room) 
		# move to next floor; unlocked when ?
		if(_floor=="A"):
			Global.hud.say("You are in entry floor level.")
			buttons.push_back(Button_Config.new("move down","",moveTo.bind("B1")))
		elif(_floor=="B"):
			buttons.push_back(Button_Config.new("move up","",moveTo.bind("A1")))
			buttons.push_back(Button_Config.new("move down","",moveTo.bind("C1")))
		elif(_floor=="C"):
			buttons.push_back(Button_Config.new("move up","",moveTo.bind("B1")))
			buttons.push_back(Button_Config.new("move down","",moveTo.bind("D1")))
		elif(_floor=="D"):
			buttons.push_back(Button_Config.new("move up","",moveTo.bind("C1")))
		# move to known room in this floor
		for _r in _explored:
			buttons.push_back(Button_Config.new("goto "+_r,"",moveTo.bind(_r)))
		
		# when moving from room to next, something can happe; afterwards there is a chance that you go back to first room
		# explore this floor to find room
		#var _evts=Global.ES.pickEvents(EventSystem.TRIGGER.Explore,_evtName,2,[])
		#if(_evts.size()>0):
		#	for _evt:EventBase in _evts:
		#		buttons.push_back(Button_Config.new(Util.pickRandomFromArray([_evt.getName(),"???"]),
		#			"",_evt.react.bind(EventSystem.TRIGGER.Explore).bind(_evtName).bind([])))
		buttons.push_back(Button_Config.new("Explore","",explore))
		# item pickup
		var _item = _items[_room] if _items.has(_room) else null
		if(_item):
			Global.hud.say("There is an "+_item+" laying around.")
			buttons.push_back(Button_Config.new("Pickup "+_item,"",pickupItem.bind(_room,_item)))

		buttons.push_back(Button_Config.new("...","",parent_scene.menu.bind("other")))
		#buttons.push_back(Button_Config.new("explore","",parent_scene._on_bt_explore_pressed))
	if(menuid=="other"):
		Global.hud.say("What else could you do?")
		Global.hud.say("Also check your inventory.")
		buttons.push_back(Button_Config.new("Give up","",CombatSetup.defaultDefeat.bind(null)))
		if(GR.getModuleFlag("Default","Found_Library",0)>0):
			buttons.push_back(Button_Config.new("Library","",Global.main.runScene.bind("nav_castle_library")))
		
	return(buttons)

func printRoomDesc(room:String):
	Global.hud.say(room+ "- Just an empty cave.") #todo room description

func pickupItem(room:String,item:String):
	var _items:Dictionary=GR.getFlag("Default.Dungeon_Items",{})
	_items.erase(room)
	GR.setFlag("Default.Dungeon_Items",_items)
	Global.pc.inventory.addItem(GR.createItem(item))
	
func moveTo(newroom:String):
	GR.setFlag("Default.Dungeon_TargetRoom",newroom)
	pass

func explore():
	var _room:String=GR.getFlag("Default.Dungeon_Room","")
	var _floor:String=_room.substr(0,1)
	var _explored:Array = GR.getFlag("Default.Dungeon_RoomsExplored",{}).keys()
	var _rooms:Array=GR.getFlag("Default.Dungeon_Rooms",{}).keys()
	_rooms=_rooms.filter(func(x):return x.substr(0,1)==_floor)
	_rooms=_rooms.filter(func(x):return !_explored.has(x))
	var _Roll=45
	var _Encs:=[]
	# possible encounters
	if(_floor=="A"):
		_Encs=[
			{"id":"evt_VineSnare",     "Agility":_Roll-5,    "Strength":_Roll,    "Intelect":_Roll-5,  "Rnd":10},
			#{"id":"evt_VineGrab",      "Agility":_Roll,      "Strength":_Roll-5,  "Intelect":_Roll+5,  "Rnd":10},
			#{"id":"evt_ExploreFail","Rnd":10}
			]
	
	# find a room on this floor that havent been found
	var nextRoom=Util.pickRandomFromArray(_rooms)
	if(!nextRoom):
		Global.hud.say("It seems you explored all in this area.")
		return
	var _Enc=Util.pickRandomFromArray(_Encs)
	var rnd=Util.randomNormal(0,40,3)	# todo depends on all stats?
	if(rnd<0 && _Enc): # encounter
		Global.main.runScene("interaction_scene",
		[_Enc.id,
		Global.main.getCurrentScene().get_bg()],
		Global.main.getCurrentScene().uniqueSceneID)
		#Global.main.runScene(_Enc.id,[_Enc],Global.main.currentSceneUID)
	else:
		GR.setFlag("Default.Dungeon_TargetRoom",nextRoom)
		Global.main.runScene(sceneID)	#reusing this for all rooms
