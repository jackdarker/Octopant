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
#var player_pos:DungeonRoom	#actual room in the map
var prev_pos:String
var lastInteracted:String

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
	#Global.pc.location=self.sceneID+"|"+player_pos.roomID
	#Global.main.doTimeProcess(5*60)
	renderRoom()

func react_scene_end(_savedTag, _args):
	pass#prev_pos=null	#hack to enforce room.onenter 

func _teleport(_room:DungeonRoom):
	#if(player_pos!=_room):
	#	player_pos=_room
	if(Global.pc.location!=_room.roomID):
		Global.pc.location=_room.roomID
		enterScene()


#func moveDirection(from:DungeonRoom,dir):
#	moveTo(Global.World.getRoomByID(Global.World.applyDirectionID(from.roomID,dir)))

## trys to move player. there might be interceptions throwing you back
#func moveTo(target:DungeonRoom):
#	if(!target):
#		Log.error("invalid target")
#		return
#	var _intercept=beforeMove(prev_pos,target)
#	if(!_intercept.OK):
#		moveCB.call()
#		return
#	prev_pos=player_pos
#	player_pos=target
#	enterScene()

## triggers on_enter and adjust map-view
func updatePosition():
	var room=Global.World.getRoomByID(Global.pc.location)
	if(Global.pc.location!=prev_pos):
		for ext in scene_ext:
			ext.on_move(room)
		prev_pos=Global.pc.location
		#room._onEnter()	#TODO addAction is called here, should we separate this?
	Global.World.aimCamera(Global.pc.location)

## if this returns false, the move is unsuccesful (stays in old room) and a scene is shown
func beforeMove(from:DungeonRoom,to:DungeonRoom)->Result:
	var _res:=Result.create(true,"")
	for ext in scene_ext:
		_res=ext.beforeMove(from,to)
		if(!_res.OK):	#TODO with multiple ext this could cause to trigger many times before move succeeds
			break
	return(_res)
## if this returns false, a scene is injected and if the outcome is successful, the move is completed

func renderRoom():
	var mobs = Global.World.getRoomByID(Global.pc.location).getMobs()
	for mob in mobs:
		Global.hud.say(mob.getName()+" is around.")

#region DefaultExtension
## this extension is added before others and contains some basic dungeon stuff
class DefaultExt extends SceneExtension:
	func on_setupScene():
		pass

	func on_enterScene():
		var _room=Global.World.getRoomByID(Global.pc.location)
		if(_room):
			Global.hud.say("You are in "+_room.roomName)

	func get_buttons(menuid:String,buttons:Array)->Array: 
		var room=Global.World.getRoomByID(Global.pc.location)
		if(menuid==""):
			# add move keys
			if(!Global.pc.effects.hasItemID("eff_trapped")):
				for x in GameWorld.getAllDirections():
					var _move#=TaskMove.new()
					_move.moveDirection(room.roomID,x)
					buttons.push_back(Button_Config.new(_move.get_label(),_move.get_tooltip(),
						Global.pc.assignTask.bind(_move),_move.canRun))
			
					#buttons.push_back(Button_Config.new("to "+str(x),"",
					#	parent_scene.moveDirection.bind(GameWorld.Direction[x]).bind(room),
					#	_cango.bind(GameWorld.Direction[x]).bind(room)))
			else:
				pass
			# add interactables or task
			var actions=room.getInteractables("")
			for action in actions:
				if(action is RoomInteractable):
					buttons.push_back(Button_Config.new(action.get_label(), 
						action.get_tooltip(),parent_scene.menu.bind(action.get_label())))
				else: # is task
					buttons.push_back(Button_Config.new(action.get_label(), 
						action.get_tooltip(),Global.pc.assignTask.bind(action),action.canRun ))
		else: #is this InteractableID? -> add actions
			var actions=room.getInteractables(menuid)
			for action in actions:
				buttons.push_back(Button_Config.new(action.get_label(), 
					action.get_tooltip(),Global.pc.assignTask.bind(action),action.canRun ))
			# see also RoomInteractable
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
