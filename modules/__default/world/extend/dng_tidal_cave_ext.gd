extends SceneExtension

## scene extension for dungeon scene

const sceneID="dng_tidal_cave"
const entry:Vector3i=Vector3i(0,1,0)

var state:int=0


func on_setupScene():
	parent_scene.player_pos=Global.World.getRoomByID("TidalCaveEntry")
	assert(parent_scene.player_pos!=null)
	pass

func on_enterScene():
	parent_scene.set_bg(load("res://assets/images/bg/nav_beach_sun.png"))

func get_buttons(menuid:String,buttons:Array):
	return(buttons)

## called when a room is entered
func on_move(target:DungeonRoom):
	state=0		

func beforeMove(from:DungeonRoom,to:DungeonRoom)->Result:
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
	
