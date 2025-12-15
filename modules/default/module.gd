extends Module

func _init()-> void :
	id = "DefaultModule"
	author = "TheAuthor"
	
	scenes = [
		"res://modules/default/world/nav_beach.tscn",
		]

func getFlags():
	return {
		"Explored_Beach": flag(FlagType.Number),
		}
