class_name ActionLeave extends RoomAction

@export var target:String	#this is either a roomID or some scene

func _ready() -> void:
	super()
	if(label=="" || label=="some action"):
		label= "goto "+target

func can_run()->Result:
	var _res:Result=Result.create(true,"")
	return _res

func run():
	var _room=Global.World.getRoomByID(target)
	if(_room):
		_room._onEnter()
	else:
		Global.main.runScene(target)
