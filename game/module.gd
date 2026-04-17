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
var recipes = []
var quests = []

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
		GR.registerScene(ID,GR.module_basepath(scene), author)
	
	for scene in scene_ext:
		GR.registerSceneExtension(ID,GR.module_basepath(scene), author)
	
	for item in items:
		GR.registerItem(ID,GR.module_basepath(item))
		
	for recipe in recipes:
		GR.registerRecipe(ID,GR.module_basepath(recipe))
		
	for event in events:
		GR.registerEvent(ID,GR.module_basepath(event))
	
	for effect in effects:
		GR.registerEffect(ID,GR.module_basepath(effect))
	
	for skill in skills:
		GR.registerSkill(ID,GR.module_basepath(skill))
	
	for character in characters:
		GR.registerCharacter(ID,GR.module_basepath(character))
	
	for quest in quests:
		GR.registerQuest(ID,GR.module_basepath(quest))

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
