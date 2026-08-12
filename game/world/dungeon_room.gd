class_name DungeonRoom extends Node2D

@export var roomName := ""	#leave mepty to auto-generate
@export var roomID := ""	#id needs to be unique in world; leave mepty to auto-generate
@export_multiline var roomDescription := ""
@export_multiline var blindRoomDescription := ""
@export var canWest = true
@export var canNorth = true
@export var canEast = true
@export var canSouth = true
var lastVisited:int=0

signal onEnter(room)
signal onPreEnter(room)
#signal onReact(room, key)

var astarID
@export var astarConnectedTo:Array[String]= []	# this is used by NPC; add ActionLeave for PC!
var astarConnections:Array = []

var NPCIcon=preload("res://game/world/interactables/npc.tscn")

func _ready() -> void:
	if(!roomID):
		roomID = getFloorID()+"@"+name	# "DngABC_Floor1@Room 1
	if(!roomName):
		roomName = name

func saveData()->Variant:
	var data ={	
		#"item":self.get_script().resource_path,	#get_script().get_global_name(),
		"scene" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"roomName":roomName,
		"roomID": roomID,
		"name":name,
		"pos_X": position.x,
		"pos_Y": position.y,
		"W": canWest,
		"S": canSouth,
		"E": canEast,
		"N": canNorth,
	}
	return(data)

func postLoad():
	pass

## distribute interactable-icons in a grid
func _alignIcons():
	if(visible):
		var _groups={}
		for child:Node in get_children().filter(func(x):return(x is RoomInteractable)):
			#var _class=child.get("class_name") doesnt work
			var _class=Vector2(8,8)*child.getIconOffset() #_class is vector
			if(!_groups.has(_class)):
				_groups[_class]=[]
			_groups[_class].push_back(child)
		
		for _class in _groups.keys():
			for child in _groups[_class]:
				child.position=_class

#if ID is empty, returns a list of all interactable in the room [cabinet,NPC1]
# but if the interactable has only 1 action returns the action
#if ID is given returns a list of possible actions "cabinet"->[open,inspect]
func getInteractables(InteractableID:String, _char:Character=Global.pc)->Array:
	var actions=[]
	var tmpActions
	var objects = get_children().filter(func(x): return (x is RoomInteractable && x.get_hidden()==0))
	if(InteractableID==""):
		for _item in objects:
			tmpActions=_item.getAvailableActions(_char)
			if(tmpActions.size()==0):	#no actions for interacta
				pass
			elif(tmpActions.size()==1):	#if there is only 1 action dont make submenu
				actions.push_back(tmpActions[0])
			elif(objects.size()==1):	#if only 1 interactable just return its action
				actions=tmpActions
			else:
				actions.push_back(_item)
		return actions
	#-----------------
	var _item=objects.filter(func(x):return(x.label==InteractableID))[0]
	assert(_item!=null)
	if(_item):
		return _item.getAvailableActions(_char)
	
	return actions

func getMobs()->Array[Character]:
	var _Mobs:Array[Character]=[]
	var _Mob
	for mobid in getFloor().Mobs:
		_Mob=GR.getUniqueCharacter(mobid)
		if (roomID==_Mob.location):
			_Mobs.push_back(_Mob)
	return(_Mobs)

func processTime(_dt:int):
	var _mobsOld=get_children().filter(func(x):return(x is NPCIcon))
	var _mobsHere=[]
	for mobID in getFloor().Mobs:
		var _mob=GR.getUniqueCharacter(mobID)
		if(_mob.location==roomID):
			_mobsHere.push_back(_mob)
	var _mobsNew=[]
	#remove icon from removed NPC
	var _mobsOld2=_mobsOld.filter(func(x):return (!_mobsHere.any(func(y):return(y.uniqueID==x.ID))))
	for _mob in _mobsOld2:
		remove_child(_mob)
		_mob.queue_free()
	#add icons from new NPC
	_mobsHere=_mobsHere.filter(func(x):return(!_mobsOld.any(func(y):return(y.ID==x.uniqueID))))
	for _mob:Character in _mobsHere:
		var _icon:=NPCIcon.instantiate()
		_icon.ID=_mob.uniqueID
		_icon.label=_mob.getName()
		add_child(_icon)


func _onPreEnter():
	emit_signal("onPreEnter", self)

func _onEnter():
	lastVisited=Global.main.getTime()
	emit_signal("onEnter", self)

func setHighlighted(high):
		$room.self_modulate=GameWorld.HIGHLIGHT if(high) else Color.WHITE

func getFloorID():
	return getFloor().ID
	
func getFloor()->DungeonFloor:
	var myParent = get_parent()
	while(!myParent.has_method("getRooms")):
		myParent = myParent.get_parent()
	return myParent

func getScene()->Node:
	var myParent = get_parent()
	while(!myParent.has_method("getRooms")):
		myParent = myParent.get_parent()
	return myParent

## returns coordinated of the room on the floor
func getCell() -> Vector2:
	return Vector2(round(global_position.x / GameWorld.GRID), round(global_position.y / GameWorld.GRID))
