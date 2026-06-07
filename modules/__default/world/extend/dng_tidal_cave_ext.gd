extends SceneExtension

const sceneID="dng_tidal_cave"
const entry:Vector3i=Vector3i(0,1,0)

var state:int=0


func on_setupScene():
	# setup the dungeon
	parent_scene.player_pos=entry
	parent_scene.map_data=DungeonScene.DungeonMap.new()
	var roomA=DungeonScene.DungeonRoom.create(Vector3i(0,1,0),"Room1")
	var roomB=DungeonScene.DungeonRoom.create(Vector3i(0,2,0),"Room2")
	var roomC=DungeonScene.DungeonRoom.create(Vector3i(0,3,0),"Room3")
	roomC.exit="nav_beach"
	parent_scene.map_data.addRoom(roomA).addRoom(roomB).addRoom(roomC)
	parent_scene.map_data.addDoor(DungeonScene.DungeonDoor.create(roomA,roomB,false))
	parent_scene.map_data.addDoor(DungeonScene.DungeonDoor.create(roomB,roomC,false))

func on_enterScene():
	var room=parent_scene.map_data.getRoomByPos(parent_scene.player_pos)
	parent_scene.set_bg(load("res://assets/images/bg/nav_beach_sun.png"))
	#TODO update map
	Global.hud.say("You are in "+room.label)

func get_buttons(menuid:String,buttons:Array):
	var room=parent_scene.map_data.getRoomByPos(parent_scene.player_pos)
	var doors=parent_scene.map_data.getDoorsByPos(parent_scene.player_pos)
	if(menuid==""):
		Global.hud.say("Where would you like to go?")
		for x in doors.values():
			buttons.push_back(Button_Config.new("to "+x.label,"",parent_scene.attemptMove.bind(x)))
		if(room.exit!=""):
			buttons.push_back(Button_Config.new("Leave","",Global.main.runScene.bind(room.exit)))
	
	return(buttons)


## called when a room is entered
func on_move(target:DungeonScene.DungeonRoom):
	state=0

func beforeMove(from:DungeonScene.DungeonRoom,to:DungeonScene.DungeonRoom)->Result:
	var _res:=Result.create(true,"")
	if(state<1):
		state=1
		_res.OK=false
		_res.Msg="Someone approaches..."
	parent_scene.moveCB=_enemy_encounter
	return(_res)

func _enemy_encounter():
	Global.hud.clearInput()
	Global.hud.say("Someone approaches...")
	Global.hud.addButton("Next","",_on_bt_fight_pressed)

func _on_bt_fight_pressed():
	var _setup=CombatSetup.new()
	_setup.onVictory= _postVictory
	_setup.onDefeat= _postDefeat
	_setup.onFlee= _postDefeat
	_setup.onSubmit= _postDefeat
	_setup.playerParty.push_back(Global.pc)
	var _mob=Util.pickRandomFromArray(["Crab","JellyFish"])
	_setup.enemyParty.push_back(GR.createCharacter(_mob))
	Global.main.runScene("combat_scene",
		[_setup],parent_scene.uniqueSceneID)

func _postVictory(combatScene):
	Global.hud.say("You have won this fight")	#todo fetchloot
	Global.hud.addButton("Next","",func():Global.main.removeScene(combatScene))

func _postDefeat(combatScene):
	parent_scene._defeated=true
	Global.hud.say("After loosing that fight you find yourself washed up at the shoreline.")	#todo fetchloot
	Global.hud.addButton("Next","",	func():Global.main.removeScene(combatScene))
	
