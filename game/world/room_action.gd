class_name RoomAction extends Node

## something the player can interact with in a room


@export var label:="some action"

func _ready() -> void:
	pass

func can_run()->Result:
	var _res:Result=Result.create(false,"")
	return _res

func run():
	pass

# 0= visible, 1=hide label, 255=show nothing
func hidden()->int:
	return 0

func get_tooltip()->String:
	return ""
