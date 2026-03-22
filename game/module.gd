extends Node
class_name Module

var ID = "badmodule"
var author = "no author"
var scenes = []
var scene_ext = []
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
		GR.registerScene(ID,scene, author)
	
	for scene in scene_ext:
		GR.registerSceneExtension(ID,scene, author)
	
	for item in items:
		GR.registerItem(ID,item)
	
	for event in events:
		GR.registerEvent(ID,event)
	
	for effect in effects:
		GR.registerEffect(ID,effect)
	
	for skill in skills:
		GR.registerSkill(ID,skill)
	
	for character in characters:
		GR.registerCharacter(ID,character)

#override this !
func registerEventTriggers():
	pass

#override this !
func resetFlagsOnNewDay():
	pass

#func setFlag(flagID, value):
#	GR.setFlag(flagID, value)

#func getFlag(flagID, defaultValue = null):
#	return GR.getFlag(flagID, defaultValue)

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
