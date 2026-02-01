extends Node
class_name Module

var ID = "badmodule"
var author = "no author"
var scenes = []
var items = []
var events = []
var effects = []
var skills = []
var characters = []


var flagsCache = null

func _init():
	flagsCache = getFlags()
	
func preInit(): # Called before anything gets registered
	pass

func postInit(): # Called after everything is registered
	pass
	
func initGame(): # Called when game engine starts
	pass

func register():
	for scene in scenes:
		GlobalRegistry.registerScene(scene, author)
	
	for item in items:
		GlobalRegistry.registerItem(item)
	
	for event in events:
		GlobalRegistry.registerEvent(event)
	
	for effect in effects:
		GlobalRegistry.registerEffect(effect)
	
	for skill in skills:
		GlobalRegistry.registerSkill(skill)
	
	for character in characters:
		GlobalRegistry.registerCharacter(character)

#override this !
func registerEventTriggers():
	pass

#override this !
func resetFlagsOnNewDay():
	pass

func setFlag(flagID, value):
	GlobalRegistry.setFlag(flagID, value)

func getFlag(flagID, defaultValue = null):
	return GlobalRegistry.getFlag(flagID, defaultValue)

func getRandomSceneFor(_sceneType):
	return []

#override this to return your module-flags!
func getFlags():
	return {}
	
func getFlagsCache():
	return flagsCache

func flag(type):
	return {
		"type": type,
	}

#override this to fix flags after loading old savegame
#TODO remove/fix flags that are not in flagscache (=not present anymore)
func postLoadCleanupFlags(data):
	return data
