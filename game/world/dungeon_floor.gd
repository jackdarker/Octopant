class_name DungeonFloor extends Node2D

## a world can have multiple floors
## each floor has multiple rooms 
## rooms need to be arranged in quadratic grid with possible connection in 4 directions
## a room can also connect to a room in a different floor (stairs)


@export var ID:=""
@export var floorName:=""


func _ready() -> void:
	if(!ID):
		ID = name
	if(!floorName):
		floorName = ID


func getRooms()->Array[DungeonRoom]:
	var result:Array[DungeonRoom] = []
	
	for r in get_children():
		#if(r is SubGameWorld):
		#	result.append_array(getRoomsRecursive(r))
		#elif(r is MapDecoration):
		#	continue
		if(r is DungeonRoom):
			result.append(r)
		
	return result
			
#func getRoomsRecursive(node):
#	var result = []
#	for r in node.get_children():
#			result.append(r)
#		elif(r is MapDecoration):
#			continue
#		else:
#			result.append_array(getRoomsRecursive(r))
#	
#	return result
