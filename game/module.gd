extends Node
class_name Module

var id = "badmodule"
var author = "no author"
var scenes = []

var flagsCache = null

func _init():
	flagsCache = getFlags()
	
func preInit(): # Called before anything gets registered
	pass

func postInit(): # Called after everything is registered
	pass

func register():
	for scene in scenes:
		GlobalRegistry.registerScene(scene, author)
		

func registerEventTriggers():
	pass

func resetFlagsOnNewDay():
	pass

func setFlag(flagID, value):
	GlobalRegistry.setFlag(flagID, value)

func getFlag(flagID, defaultValue = null):
	return GlobalRegistry.getFlag(flagID, defaultValue)

func getRandomSceneFor(_sceneType):
	return []

func getFlags():
	return {}
	
func getFlagsCache():
	return flagsCache

func flag(type):
	return {
		"type": type,
	}
