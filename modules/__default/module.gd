class_name Module_Default extends Module

func _init()-> void :
	super()
	ID = "Default"
	author = "TheAuthor"
	
	map_floors = [
		"res://modules/__default/world/dungeon",
		]
	
	scenes = [
		"res://modules/__default/world",
		]
	scene_ext = [
		"res://modules/__default/world/extend",
		"res://modules/__default/interaction",
		]
	items = [
		"res://modules/__default/item",
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
	tutorials = [
		"res://modules/__default/tutorial",
	]
	quests = [
		"res://modules/__default/quest",
	]

func getFlags():
	return {
		"Beach_Shack": flag(FlagType.Number),
		"Found_Beach": flag(FlagType.Number),	#has found region
		"Found_Cliff": flag(FlagType.Number),
		"Found_Forest": flag(FlagType.Number),
		"Found_Tunnel": flag(FlagType.Number),
		"Explored_Beach": flag(FlagType.Number),	#times explored region
		"Explored_Cliff": flag(FlagType.Number),
		"Explored_Forest": flag(FlagType.Number),
		"FatigueFactor_Beach": flag(FlagType.Number),	#fatigue-reduction bonus
		"FatigueFactor_Forest": flag(FlagType.Number),
		"Cliff_Height": flag(FlagType.Number),	# actual climb-height of player 
		"Cliff_Ropes": flag(FlagType.Number),	# how many ropes are installed from bottom to up
		"FaintMessage": flag(FlagType.Text),	#text why player fainted
		"FatigueHigh":	flag(FlagType.Number),
		}

func initGame():
	#setup triggers for events
	Global.ES.registerEvent(EventSystem.TRIGGER.InRoom,GR.getEvent("EventVisStat"),"",[])
	Global.ES.registerEvent(EventSystem.TRIGGER.EnterRoom,GR.getEvent("EventNothing"),"nav_beach_explore",[])
	Global.ES.registerEvent(EventSystem.TRIGGER.EnterRoom,GR.getEvent("EventFindLootBeach"),"nav_beach_explore",[])
	Global.ES.registerEvent(EventSystem.TRIGGER.EnterRoom,GR.getEvent("EventFindPathCliff"),"nav_beach_explore",[])
	Global.ES.registerEvent(EventSystem.TRIGGER.EnterRoom,GR.getEvent("EventHurtBeach"),"nav_beach_explore",[])
	Global.ES.registerEvent(EventSystem.TRIGGER.EnterRoom,GR.getEvent("EventFindTroubleBeach"),"nav_beach_explore",[])
	Global.ES.registerEvent(EventSystem.TRIGGER.EnterRoom,GR.getEvent("EventFindPathForest"),"nav_beach_explore",[])
	Global.ES.registerEvent(EventSystem.TRIGGER.EnterRoom,GR.getEvent("EventExploreUpgrade"),"nav_beach_explore",[])
	Global.ES.registerEvent(EventSystem.TRIGGER.EnterRoom,GR.getEvent("EventFindLootForest"),"nav_forest_explore",[])
	Global.ES.registerEvent(EventSystem.TRIGGER.EnterRoom,GR.getEvent("EventExploreUpgrade"),"nav_forest_explore",[])
	Global.ES.registerEvent(EventSystem.TRIGGER.EnterRoom,GR.getEvent("EventFindLootCliff"),"nav_cliff_explore",[])
