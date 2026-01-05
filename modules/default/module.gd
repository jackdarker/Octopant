extends Module

func _init()-> void :
	super()
	id = "DefaultModule"
	author = "TheAuthor"
	
	scenes = [
		"res://modules/default/world",
		]
	items = [
		"res://modules/default/Item/vial_empty.gd",
	]
	events = [
		"res://modules/default/event/event_nothing.gd",
		"res://modules/default/event/event_find_loot_beach.gd",
		"res://modules/default/event/event_find_path_cliff.gd",
	]

func getFlags():
	return {
		"Found_Beach": flag(FlagType.Number),
		"Found_Cliff": flag(FlagType.Number),
		"Explored_Beach": flag(FlagType.Number),
		}

func initGame():
	#setup triggers for events
	Global.ES.registerEvent(EventSystem.TRIGGER.EnterRoom,GlobalRegistry.getEvent("EventNothing"),"nav_beach_explore",[])
	Global.ES.registerEvent(EventSystem.TRIGGER.EnterRoom,GlobalRegistry.getEvent("EventFindLootBeach"),"nav_beach_explore",[])
	Global.ES.registerEvent(EventSystem.TRIGGER.EnterRoom,GlobalRegistry.getEvent("EventFindPathCliff"),"nav_beach_explore",[])
	pass
