class_name GameWorld extends Node2D

## contains all floors
enum Direction {WEST, NORTH, EAST, SOUTH}
const GRID:int=64	#room to room grid
const HIGHLIGHT:=Color.CHOCOLATE

static func getAllDirections():
	return [Direction.WEST, Direction.NORTH, Direction.EAST, Direction.SOUTH]

static func getOppositeDir(theDir):
	if(theDir == Direction.WEST):
		return Direction.EAST
	if(theDir == Direction.NORTH):
		return Direction.SOUTH
	if(theDir == Direction.EAST):
		return Direction.WEST
	if(theDir == Direction.SOUTH):
		return Direction.NORTH
	return -1

var roomScene = preload("res://game/world/dungeon_room.tscn")
var roomConnectionScene = preload("res://game/world/dungeon_connection.tscn")
var worldFloorScene = preload("res://game/world/dungeon_floor.tscn")
@onready var camera=$Camera2D
#@onready var mapview=$SubViewport
var astar:AStar2D
var astarIDToRoomIDMap:={}
var floorDict:={}
var roomDict:={}
var cells:={}
var lastAimedRoomID:=""
var highlightedRoom:DungeonRoom

func _ready()->void:
	astar = AStar2D.new()
	# load all the (persistent) maps and merge them into world
	var mapFloors = {"map1": "res://modules/__default/world/dungeon/map_tidal_cave.tscn"} #GR.getMapFloors()
	for mapID in mapFloors:
		var mapPath = mapFloors[mapID]
		var mapObject = load(mapPath).instantiate()
		
		#var newWorldFloor = worldFloorScene.instantiate()
		#newWorldFloor.ID = mapID
		#add_child(newWorldFloor)
		#newWorldFloor.add_child(mapObject)
		add_child(mapObject)
	
		#if(mapObject.get("canMeetNPCs")):
		#	newWorldFloor.canMeetNPCs = mapObject.canMeetNPCs
	
	for f in get_children():
		if(f.has_method("getRooms")):
			if(floorDict.has(f.ID)):
				assert(false)
			floorDict[f.ID] = f
			if(!cells.has(f.ID)):
				cells[f.ID] = {}
			var _cells = f.getRooms()
			
			for cell in _cells:	#fix position in case wasnt placed accuratly
				cell.global_position.x = round(cell.global_position.x / GRID) * GRID
				cell.global_position.y = round(cell.global_position.y / GRID) * GRID
				
				registerRoom(f.ID, cell)
	camera.get_viewport()
	addTransitions()
	aimCamera("room 1",true)

func hasRoom(floorid: String, pos: Vector2):
	if(!cells.has(floorid)):
		return false
	
	if(!cells[floorid].has(pos)):
		return false
	
	return true

func getRoomByID(id:String):
	if(!roomDict.has(id)):
		return null
	return roomDict[id]

func applyDirection(pos: Vector2, dir:Direction):
	var newpos = pos
	if(dir == Direction.WEST):
		newpos.x -= 1
	elif(dir == Direction.NORTH):
		newpos.y -= 1
	elif(dir == Direction.EAST):
		newpos.x += 1
	elif(dir == Direction.SOUTH):
		newpos.y += 1
	return newpos

## returns the roomid of the connected room in direction 	
func applyDirectionID(roomid: String, dir:Direction) -> String:
	var room = getRoomByID(roomid)
	if(!room):
		return ""
	var currentFloor = room.getFloorID()
	
	var newpos = applyDirection(room.getCell(), dir)
	if(hasRoom(currentFloor, newpos)):
		return cells[currentFloor][newpos].roomID
	else:
		return ""
	
func canGoID(roomid: String, dir):
	var room = getRoomByID(roomid)
	if(!room):
		return false
	
	return canGo(room.getFloorID(), room.getCell(), dir)
	
func canGo(floorid: String, pos: Vector2, dir):
	if(!hasRoom(floorid, pos)):
		return false
	var pos2 = applyDirection(pos, dir)
	if(!hasRoom(floorid, pos2)):
		return false
	
	var room1 = cells[floorid][pos]
	var room2 = cells[floorid][pos2]
	if(dir == Direction.WEST):
		if(room1.canWest && room2.canEast):
			return true
		return false
	if(dir == Direction.EAST):
		if(room1.canEast && room2.canWest):
			return true
		return false
	if(dir == Direction.NORTH):
		if(room1.canNorth && room2.canSouth):
			return true
		return false
	if(dir == Direction.SOUTH):
		if(room1.canSouth && room2.canNorth):
			return true
		return false
	return false

func registerRoom(floorid, room):
	var pos:Vector2 = room.getCell()
	
	if(hasRoom(floorid, pos)):
		Log.error("Map Error: there is already a room at cell "+str(pos)+" floor: "+str(floorid)+" roomid: "+str(room.roomID))
		room.queue_free()
		return
		
	if(!room.roomID):
		Log.error("Map Error: room at "+str(pos)+" has no roomID")
	else:
		if(roomDict.has(room.roomID)):
			Log.error("Map Error: room with id "+room.roomID+" is already registered")
			room.queue_free()
			return
		roomDict[room.roomID] = room
	
	if(!cells.has(floorid)):
		cells[floorid] = {}
	
	cells[floorid][pos] = room
	room.astarID = astar.get_available_point_id()
	astar.add_point(room.astarID, pos)
	astarIDToRoomIDMap[room.astarID] = room.roomID

func clearFloor(floorID:String):
	if(!cells.has(floorID)):
		return
	var floorcells = cells[floorID]
	for pos in floorcells.keys():
		var _room = floorcells[pos]
		
		roomDict.erase(_room.roomID)
		for otherRoomAStarID in _room.astarConnections:
			if(astar.has_point(otherRoomAStarID)):
				astar.disconnect_points(_room.astarID, otherRoomAStarID)
		
		astar.remove_point(_room.astarID)
		astarIDToRoomIDMap.erase(_room.astarID)
		
		_room.queue_free()
		floorcells.erase(pos)
	
## builts the connections between rooms
# this checks neighboring rooms and their can... properties
func addTransitions(floorIDs:Array = []):
	if(floorIDs.size()<=0):
		floorIDs = cells.keys()
	
	for floorid in floorIDs:
		var floorcells = cells[floorid]
		for pos in floorcells:
			var _room = floorcells[pos]
			for extraAstarConnection in _room.astarConnectedTo:
				var extraRoom = getRoomByID(extraAstarConnection)
				if(extraRoom != null):
					astar.connect_points(_room.astarID, extraRoom.astarID)
					_room.astarConnections.append(extraRoom.astarID)
			
			if(canGo(floorid, pos, Direction.EAST)):
				var transitionLine = roomConnectionScene.instantiate()
				_room.add_child(transitionLine)
				transitionLine.global_position = (pos + Vector2(0.5, 0))*GRID
				
				var nextRoomID = applyDirectionID(_room.roomID, Direction.EAST)
				var nextRoom = getRoomByID(nextRoomID)
				astar.connect_points(_room.astarID, nextRoom.astarID)
				_room.astarConnections.append(nextRoom.astarID)
				
			if(canGo(floorid, pos, Direction.SOUTH)):
				#print("ADD TRANSITION FROM "+str(pos)+" TO SOUTH")
				var transitionLine = roomConnectionScene.instantiate()
				transitionLine.rotation_degrees = 90
				_room.add_child(transitionLine)
				transitionLine.global_position = (pos + Vector2(0, 0.5))*GRID
				
				var nextRoomID = applyDirectionID(_room.roomID, Direction.SOUTH)
				var nextRoom = getRoomByID(nextRoomID)
				astar.connect_points(_room.astarID, nextRoom.astarID)
				_room.astarConnections.append(nextRoom.astarID)

func switchToFloor(floorID):
	for myfloorid in floorDict:
		var floorObject = floorDict[myfloorid]
		
		if(myfloorid == floorID):
			floorObject.visible = true
		else:
			floorObject.visible = false

#region camera
func aimCamera(roomID, instantly:bool = false) -> bool:
	if(!(roomID is String)): # getRoomByID expects a string
		return false
	var room = getRoomByID(roomID)
	
	if(!room):
		return false
		
	switchToFloor(room.getFloorID())
		
	camera.global_position = room.global_position
	
	if(highlightedRoom):
		highlightedRoom.setHighlighted(false)
	highlightedRoom = room
	highlightedRoom.setHighlighted(true)
	
	lastAimedRoomID = roomID
	if(instantly):
		camera.reset_smoothing()
	return true

func zoomIn(mult:float = 1.0):
	camera.zoom *= 1.1 * mult
	updateDarknessSize()

func zoomOut(mult:float = 1.0):
	camera.zoom *= 0.9 / mult
	updateDarknessSize()

func zoomRaw(mult:float = 1.0):
	camera.zoom *= mult
	camera.zoom.x = clamp(camera.zoom.x, 0.2, 5.0)
	camera.zoom.y = clamp(camera.zoom.y, 0.2, 5.0)
	updateDarknessSize()

func zoomReset():
	camera.zoom = Vector2(1.0, 1.0)
	updateDarknessSize()

func updateDarknessSize():
	pass #TODO
#endregion


func _on_bt_w_pressed() -> void:
	if(canGoID(highlightedRoom.roomID,Direction.WEST)):
		aimCamera(applyDirectionID(highlightedRoom.roomID,Direction.WEST))


func _on_bt_e_pressed() -> void:
	if(canGoID(highlightedRoom.roomID,Direction.EAST)):
		aimCamera(applyDirectionID(highlightedRoom.roomID,Direction.EAST))
