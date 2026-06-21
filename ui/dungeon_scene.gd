class_name DungeonScene extends NavigationScene

## while a nav_scene consist of 1 room, a dungeon has several rooms that are somehow connected
## rooms are layed out in square grid with possible connections in 4 directions
## connections can be oneway or require a certain condition (unlocked,...)
## a dungeon can have multiple planes connected by stairs, lift,...
## things can happen while navigating from room to next 
## 
## display a map of the dungeon
## buttons to navigate 4 directions + up/down

#var player_pos:Vector3i	# the dungeon-tile the player is currently
#var map_data:DungeonMap
var moveCB:Callable	#if a move fails, run this
var _defeated:bool=false
var map_data:=""	#needs to point to map
var player_pos:DungeonRoom	#actual room in the map
var prev_pos:DungeonRoom

func setupScene():
	super()
	var DefExt:=DefaultExt.new()
	DefExt.parent_scene=self
	DefExt.on_setupScene()
	scene_ext.push_front(DefExt)
	Global.World.on_enter_room.connect(_teleport)

func enterScene():
	super()
	if(_defeated):
		Global.main.removeScene(self)
		return
	updatePosition()

func _teleport(_room):
	if(player_pos!=_room):
		player_pos=_room
		updatePosition()
		enterScene()


func moveDirection(from:DungeonRoom,dir):
	moveTo(Global.World.getRoomByID(Global.World.applyDirectionID(from.roomID,dir)))

## trys to move player. there might be interceptions throwing you back
func moveTo(target:DungeonRoom):
	if(!target):
		Log.error("invalid target")
		return
	var _intercept=beforeMove(prev_pos,target)
	if(!_intercept.OK):
		moveCB.call()
		return
	prev_pos=player_pos
	player_pos=target
	enterScene()

## triggers on_enter and adjust map-view
func updatePosition():
	if(player_pos!=prev_pos):
		for ext in scene_ext:
			ext.on_move(player_pos)
		prev_pos=player_pos
		player_pos._onEnter()	#TODO addAction is called here, should we separate this?
		
	Global.World.aimCamera(player_pos.roomID)


## if this returns false, the move is unsuccesful (stays in old room) and a scene is shown
func beforeMove(from:DungeonRoom,to:DungeonRoom)->Result:
	var _res:=Result.create(true,"")
	for ext in scene_ext:
		_res=ext.beforeMove(from,to)
		if(!_res.OK):	#TODO with multiple ext this could cause to trigger many times before move succeeds
			break
	return(_res)
## if this returns false, a scene is injected and if the outcome is successful, the move is completed

#region DefaultExtension
## this extension is added before others and contains some basic dungeon stuff
class DefaultExt extends SceneExtension:
	func on_setupScene():
		pass

	func on_enterScene():
		Global.hud.say("You are in "+parent_scene.player_pos.roomName)

	func get_buttons(menuid:String,buttons:Array)->Array: 
		var room=parent_scene.player_pos
		if(menuid==""):
			Global.hud.say("Where would you like to go?")
			for x in GameWorld.Direction.keys():
				buttons.push_back(Button_Config.new("to "+str(x),"",
					parent_scene.moveDirection.bind(GameWorld.Direction[x]).bind(room),
					_cango.bind(GameWorld.Direction[x]).bind(room)))
			# see also RoomAction
		return(buttons)

	func _cango(room,dir)->Result:	
		var _res:=Result.create(true,"")
		_res.OK=Global.World.canGo(room.getFloorID(),room.getCell(),dir)
		return _res

	func beforeMove(from:DungeonRoom,to:DungeonRoom)->Result:
		var _res:=Result.create(true,"")
		return(_res)
	
	func on_move(target:DungeonRoom):
		pass

#endregion
