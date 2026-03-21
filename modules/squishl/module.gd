extends Module

func _init()-> void :
	super()
	ID = "Squishl"
	author = "TheAuthor"
	
	scenes = [
		"res://modules/squishl/world",
		]
	#items = [
	#	"res://modules/squishl/Item",
	#]
	events = [
		"res://modules/squishl/event",		#dont forget to setup events in initGame !
	]
	#effects = [
	#	"res://modules/squishl/effect",
	#]
	#skills = [
	#	"res://modules/squishl/skill",
	#]
	characters = [
		"res://modules/squishl/character",
	]

func getFlags():
	return {
		"Squishl_Saved": flag(FlagType.Number),
		"Delve_State": flag(FlagType.Number),
		"Daily_Treasure": flag(FlagType.Number),
	}

func resetFlagsOnNewDay():
	GR.setModuleFlag(ID,"Daily_Treasure",0)

func initGame():
	#setup triggers for events
	Global.ES.registerEvent(EventSystem.TRIGGER.EnterRoom,GR.getEvent("EventMeetSquishlBeach"),"nav_beach_explore",[])
	Global.ES.registerEvent(EventSystem.TRIGGER.EnterRoom,GR.getEvent("EventDelveBeach"),"nav_beach_explore",[])
