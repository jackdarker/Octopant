class_name DungeonRoom extends Node2D

@export var roomName := ""
@export var roomID := ""
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
@export var astarConnectedTo:Array[String]= []
var astarConnections:Array = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(!roomID):
		roomID = name
	if(!roomName):
		roomName = roomID

func addActions():
	return
#	for action in get_children():
#		if(action is RoomAction):
#			var roomAction:RoomAction = action
#			if(roomAction._shouldShow()):
#				if(roomAction._canRun()):
#					GM.ui.addButton(roomAction.ActionName, roomAction.ActionTooltip, "actionCallback", [roomAction.ActionScene])
#				else:
#					GM.ui.addDisabledButton(roomAction.ActionName, roomAction.ActionTooltip)

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
