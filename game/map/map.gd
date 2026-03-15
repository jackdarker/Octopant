class_name Map extends Resource


# represents a map of world/dungeon the player can navigate on (move from location to location)
# some locations (rooms) have exits to/entrys from other maps
# locations are connected by doors

# rooms are either arranges in grid (row|colum) or floating nodes (xy-pos)
# they have a Vector3-position

# map_view can render the rooms+doors based on the map

# locations["A1"]={ pos:(0,10,0), name:bedroom,type:bedroom,interactables:[bed,mirror]}

# doors["A1_B1"]={ roomA:A1,roomB:B1, bidi:true, canuse:isunlocked("Bedroom"), use:justmove() }
var actualRoom:String
var targetRoom:String
var rooms:Dictionary
var doors:Dictionary

# override this to setup map
func _init():
	pass

#call this to check map
func sanitize():
	pass #TODO

func getDoorsForRoom(roomID:String)->Array:
	var _doors:Array=[]
	if(rooms[roomID]):
		for door in doors:
			if (door.ID==roomID):
				_doors.push_back(door)
	return(_doors)

func getInteractableForRoom(roomID:String)->Array:
	return(rooms[roomID].interactables)


class Room extends RefCounted:
	var ID:String=""
	var name:String=""
	var type:String=""	#forest, street
	var pos:Vector3=Vector3()
	var interactables:Array
	var lastVisited
	
	func _init(id:String,_name:String,_pos:Vector3):
		ID=id
		name=_name
		pos=_pos
	
class Door extends RefCounted:
	var ID:String
	var roomA:String
	var roomB:String
	var bidi:bool=true
	var canuse:Callable=func(): return(true)
	var use:Callable
	
	func _init(id:String,_roomA:String,_roomB:String):
		ID=id
		roomA=_roomA
		roomB=_roomB
