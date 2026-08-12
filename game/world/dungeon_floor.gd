class_name DungeonFloor extends Node2D

## a world can have multiple floors
## each floor has multiple rooms 
## rooms need to be arranged in quadratic grid with possible connection in 4 directions
## a room can also connect to a room in a different floor (stairs)


@export var ID:=""
@export var floorName:=""
@export var initOnStartup:=false	## TODO by default a floor is only added to world when player visits it first time, this forced to add on game-start

var Mobs:Array[String]=[]

func _ready() -> void:
	if(!ID):
		ID = name
	if(!floorName):
		floorName = ID

func getMob(mobID:String)->Character:
	return(GR.getUniqueCharacter(mobID))

func processTime(_dt:int):
	for mobid in Mobs:
		GR.getUniqueCharacter(mobid).processTime(_dt)
	for room in getRooms():
		room.processTime(_dt)	


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

func saveData()->Variant:
	var data ={	
		#"item":self.get_script().resource_path,	#get_script().get_global_name(),
		"scene" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_X": position.x,
		"pos_Y": position.y,
		"floorName":floorName,
		"ID": ID,
		"Mobs": Mobs,
	}
	return(data)

func postLoad():
	pass
