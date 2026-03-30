extends Module

func _init()-> void :
	super()
	ID = "Default"
	author = "TheAuthor"
	
	scenes = [
		"res://modules/__default/world",
		]
	scene_ext = [
		"res://modules/__default/world/extend",
		]
	items = [
		"res://modules/__default/Item",
	]
	recipes = [
		"res://modules/__default/recipe",
	]
	events = [
		"res://modules/__default/event",		#dont forget to setup events in initGame !
	]
	effects = [
		"res://modules/__default/effect",
	]
	skills = [
		"res://modules/__default/skill",
	]
	characters = [
		"res://modules/__default/character",
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
	Global.ES.registerEvent(EventSystem.TRIGGER.EnterRoom,GR.getEvent("EventNothing"),"nav_beach_explore",[])
	Global.ES.registerEvent(EventSystem.TRIGGER.EnterRoom,GR.getEvent("EventFindLootBeach"),"nav_beach_explore",[])
	Global.ES.registerEvent(EventSystem.TRIGGER.EnterRoom,GR.getEvent("EventFindPathCliff"),"nav_beach_explore",[])
	Global.ES.registerEvent(EventSystem.TRIGGER.EnterRoom,GR.getEvent("EventHurtBeach"),"nav_beach_explore",[])
	Global.ES.registerEvent(EventSystem.TRIGGER.EnterRoom,GR.getEvent("EventFindPathDeepWoods"),"nav_beach_explore",[])
	pass
