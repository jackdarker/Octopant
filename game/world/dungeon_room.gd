class_name DungeonRoom extends Node2D

@export var roomName := ""	#leave mepty to auto-generate
@export var roomID := ""	#id needs to be unique in world; leave mepty to auto-generate
@export_multiline var roomDescription := ""
@export_multiline var blindRoomDescription := ""
@export var canWest = true
@export var canNorth = true
@export var canEast = true
@export var canSouth = true

signal onEnter(room)
signal onPreEnter(room)
#signal onReact(room, key)

var astarID
@export var astarConnectedTo:Array[String]= []	# this is used by NPC; add ActionLeave for PC!
var astarConnections:Array = []

func _ready() -> void:
	if(!roomID):
		roomID = getFloorID()+"@"+name	# "DngABC_Floor1@Room 1
	if(!roomName):
		roomName = name

func addActions():
	var actions = get_children().filter(func(x): return (x is RoomAction))
	for action in actions:
		if(action.hidden()==0):
			Global.hud.addButton(action.label, action.get_tooltip(),action.run,action.can_run )
	

func _onPreEnter():
	emit_signal("onPreEnter", self)

func _onEnter():
	addActions()
	emit_signal("onEnter", self)

func setHighlighted(high):
		$room.self_modulate=GameWorld.HIGHLIGHT if(high) else Color.WHITE

func getFloorID():
	return getFloor().ID
	
func getFloor():
	var myParent = get_parent()
	while(!myParent.has_method("getRooms")):
		myParent = myParent.get_parent()
	return myParent

## returns coordinated of the room on the floor
func getCell() -> Vector2:
	return Vector2(round(global_position.x / GameWorld.GRID), round(global_position.y / GameWorld.GRID))
