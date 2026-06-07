class_name DungeonScene extends NavigationScene

## while a nav_scene consist of 1 room, a dungeon has several rooms that are somehow connected
## rooms are layed out in square grid with possible connections in 4 directions
## connections can be oneway or require a certain condition (unlocked,...)
## a dungeon can have multiple planes connected by stairs, lift,...
## things can happen while navigating from room to next 
## 
## display a map of the dungeon
## buttons to navigate 4 directions + up/down

class DungeonMap:
	var rooms:Dictionary
	var doors:Dictionary
	
	func addRoom(room:DungeonRoom)->DungeonMap:
		rooms[room.pos]=room
		return self
	
	func addDoor(door:DungeonDoor)->DungeonMap:
		doors[[door.roomA,door.roomB]]=door
		return self
		
	func getRoomByPos(_pos:Vector3i)->DungeonRoom:
		var room=self.rooms[_pos]
		return room
	
	## returns Dictionarys of rooms from here
	func getDoorsByPos(_pos:Vector3i)->Dictionary:
		var _doors:Array=doors.keys().filter(func(x): return(x[0].pos==_pos || (x[1].pos==_pos)))
		var _doors2:Dictionary={}
		for x in _doors:
			if(doors[x].roomA.pos==_pos):
				_doors2[x]=doors[x].roomB
			elif(doors[x].roomB.pos==_pos && doors[x].bidi):
				_doors2[x]=doors[x].roomA
		return (_doors2)

class DungeonRoom:
	var label:String
	var pos:Vector3i
	var exit:String=""	#set with target nav_scene for option to leave dungeon

	static func create(_pos:Vector3i, _label:String):
		var room=new()
		room.pos=_pos
		room.label=_label
		return room

class DungeonDoor:
	var roomA:DungeonRoom
	var roomB:DungeonRoom
	var bidi:bool=true
	
	func canPass(_from,_to):
		return true

	static func create(_roomA:DungeonRoom, _roomB:DungeonRoom, _bidi:bool=true):
		var door=new()
		door.bidi=_bidi
		door.roomA=_roomA
		door.roomB=_roomB
		return door	

var player_pos:Vector3i	# the dungeon-tile the player is currently
var map_data:DungeonMap
var moveCB:Callable	#if a move fails, run this
var _defeated:bool=false

func enterScene():
	super()
	if(_defeated):
		#Global.hud.clearInput()
		#Global.hud.addButton("Next","",	func():Global.main.removeScene(self))
		Global.main.removeScene(self)

func attemptMove(target:DungeonRoom):
	var from= map_data.getRoomByPos(player_pos)
	var to=target
	if(!beforeMove(from,to).OK):
		moveCB.call()	#intercept move
	else:
		moveTo(to) 

func moveTo(target:DungeonRoom):
	for ext in scene_ext:
		ext.on_move(target)
	player_pos=target.pos
	enterScene()

## if this returns false, the move is unsuccesful (stays in old room) and a scene is shown
func beforeMove(from:DungeonScene.DungeonRoom,to:DungeonScene.DungeonRoom)->Result:
	var _res:=Result.create(true,"")
	for ext in scene_ext:
		_res=ext.beforeMove(from,to)
		if(!_res.OK):	#TODO with multiple ext this could cause to trigger many times before move succeeds
			break
	return(_res)

## if this returns false, a scene is injected and if the outcome is successful, the move is completed
func inbetweenMove(from:DungeonScene.DungeonRoom,to:DungeonScene.DungeonRoom)->Result:
	var _res:=Result.create(true,"")
	return(_res)
