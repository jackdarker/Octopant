extends Module

func _init()-> void :
	super()
	ID = "Default"
	author = "TheAuthor"
	
	scenes = [
		"res://modules/default/world",
		]
	items = [
		"res://modules/default/Item",
	]
	events = [
		"res://modules/default/event",		#dont forget to setup events in initGame !
	]
	effects = [
		"res://modules/default/effect",
	]
	skills = [
		"res://modules/default/skill",
	]
	characters = [
		"res://modules/default/character",
	]

func getFlags():
	return {
		"Found_Beach": flag(FlagType.Number),
		"Found_Cliff": flag(FlagType.Number),
		"Found_DeepWoods": flag(FlagType.Number),
		"Explored_Beach": flag(FlagType.Number),
		"Explored_Cliff": flag(FlagType.Number),
		"Explored_DeepWoods": flag(FlagType.Number),
		}

func initGame():
	#setup triggers for events
	Global.ES.registerEvent(EventSystem.TRIGGER.EnterRoom,GlobalRegistry.getEvent("EventNothing"),"nav_beach_explore",[])
	Global.ES.registerEvent(EventSystem.TRIGGER.EnterRoom,GlobalRegistry.getEvent("EventFindLootBeach"),"nav_beach_explore",[])
	Global.ES.registerEvent(EventSystem.TRIGGER.EnterRoom,GlobalRegistry.getEvent("EventFindPathCliff"),"nav_beach_explore",[])
	Global.ES.registerEvent(EventSystem.TRIGGER.EnterRoom,GlobalRegistry.getEvent("EventHurtBeach"),"nav_beach_explore",[])
	Global.ES.registerEvent(EventSystem.TRIGGER.EnterRoom,GlobalRegistry.getEvent("EventFindPathDeepWoods"),"nav_beach_explore",[])
	pass
