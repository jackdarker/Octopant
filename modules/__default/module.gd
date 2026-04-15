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
		"res://modules/__default/interaction",
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
	quests = [
		"res://modules/__default/quest",
	]

func getFlags():
	return {
		"Found_Beach": flag(FlagType.Number),
		"Found_Cliff": flag(FlagType.Number),
		"Found_DeepWoods": flag(FlagType.Number),
		"Explored_Beach": flag(FlagType.Number),
		"Explored_Cliff": flag(FlagType.Number),
		"Explored_DeepWoods": flag(FlagType.Number),
		"Cliff_Height": flag(FlagType.Number),	# actual climb-height of player 
		"Cliff_Ropes": flag(FlagType.Number),	# how many ropes are installed from bottom to up
		"FaintMessage": flag(FlagType.Text),
		"FatigueHigh":	flag(FlagType.Number),
		}

func initGame():
	#setup triggers for events
	Global.ES.registerEvent(EventSystem.TRIGGER.InRoom,GR.getEvent("EventVisStat"),"",[])
	Global.ES.registerEvent(EventSystem.TRIGGER.EnterRoom,GR.getEvent("EventNothing"),"nav_beach_explore",[])
	Global.ES.registerEvent(EventSystem.TRIGGER.EnterRoom,GR.getEvent("EventFindLootBeach"),"nav_beach_explore",[])
	Global.ES.registerEvent(EventSystem.TRIGGER.EnterRoom,GR.getEvent("EventFindPathCliff"),"nav_beach_explore",[])
	Global.ES.registerEvent(EventSystem.TRIGGER.EnterRoom,GR.getEvent("EventHurtBeach"),"nav_beach_explore",[])
	Global.ES.registerEvent(EventSystem.TRIGGER.EnterRoom,GR.getEvent("EventFindPathDeepWoods"),"nav_beach_explore",[])
	Global.ES.registerEvent(EventSystem.TRIGGER.EnterRoom,GR.getEvent("EventFindLootForest"),"nav_forest_explore",[])
