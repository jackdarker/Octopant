extends Node
class_name MainScene

signal time_passed(_secondsPassed)
signal saveLoadingFinished

var sceneStack:Array=[]

var currentDay = 0
var timeOfDay = 6*60*60 # seconds since 00:00

func _ready() -> void:
	Global.ui = $Hud	# load("res://ui/hud.tscn").instance()	#GameUI
	Global.main = self
	Global.ES = EventSystem.new()
	Global.pc = Player.new()
	
	Global.ES.registerEventTriggers()
	
	time_passed.connect(Global.ui.on_time_passed)
	Global.pc.stat_changed.connect(Global.ui.on_pc_stat_update)
	
	#goto_scene("res://modules/default/world/nav_beach.tscn")	#todo intro
	runScene("nav_beach")

func runScene(id, _args = [], parentSceneUniqueID = -1):
	defferedRunScene.call_deferred(id,_args, parentSceneUniqueID )

func defferedRunScene(id, _args = [], parentSceneUniqueID = -1):
	var actual_scene = getCurrentScene()
	if(actual_scene):
		actual_scene.free()
	# Load the new scene.
	print("Starting scene "+id)
	#var s = ResourceLoader.load(path)
	actual_scene = GlobalRegistry.createScene(id)
	if(parentSceneUniqueID >= 0):
		actual_scene.parentSceneUniqueID = parentSceneUniqueID
	# Add it to the active scene, as child of root.
	get_node("Scene").add_child(actual_scene)
	sceneStack.append(actual_scene)

func removeScene(scene, args = []):
	defferedRemoveScene.call_deferred(scene,args)
	
func defferedRemoveScene(scene, args = []):
	if(sceneStack.has(scene)):
		var isCurrentScene = (scene == sceneStack.back())
		var savedParentSceneID = scene.parentSceneUniqueID
		var savedTag = [] #todo scene.sceneTag
		
		sceneStack.erase(scene)
		
		var parentScene = getSceneByUniqueID(savedParentSceneID)
		if(parentScene != null):
			parentScene.react_scene_end(savedTag, args)
		
		#if(isCurrentScene && sceneStack.back() != null):
		#	sceneStack.back().updateCharacter()
		#runCurrentScene()
	if(sceneStack.size() == 0):
		Log.print("Error: no more scenes in the scenestack")
		Global.ui.clearInput()
		Global.ui.say("Error: no more scenes in the scenestack. Please let the developer know")
		return

func getSceneByUniqueID(uID):
	if(uID < 0):
		return null
	for scene in sceneStack:
		if(scene.uniqueSceneID == uID):
			return scene
	return null

func getCurrentScene():
	if(sceneStack.size() > 0):
		return sceneStack.back()
	return null

func endCurrentScene(keepWorld:bool=true):
	if(sceneStack.size() == 1 && keepWorld):
		#IS.stopInteractionsForPawnID("pc")
		return
	var currentScene = getCurrentScene()
	if(currentScene != null):
		currentScene.endScene()

func clearSceneStack():
	for scene in sceneStack:
		scene.queue_free()
	sceneStack = []

func getTime():
	return timeOfDay

func getDayTimeEnd():
	return 23 * 60 * 60
	
func getDayTimeStart():
	return 7 * 60 * 60

func isVeryLate():
	return timeOfDay >= getDayTimeEnd()

func getDays():
	return currentDay

func doTimeProcess(_seconds):
	# This splits long sleeping times into 1 hour chunks
	#if(!PS):
		#IS.processTime(_seconds)
		#SCI.processTime(_seconds)
	
	var copySeconds = _seconds
	while(copySeconds > 0):
		var clippedSeconds = min(60*60, copySeconds)
		#GM.pc.processTime(clippedSeconds)
		
		#for characterID in charactersToUpdate:
		#	var character = getCharacter(characterID)
		#	if(character != null):
		#		character.processTime(clippedSeconds)
		
		copySeconds -= clippedSeconds
	
	
	var oldHours = int((timeOfDay - _seconds) / 60 / 60)
	var newHours = int(timeOfDay / 60 / 60)
	var hoursPassed = newHours - oldHours

	if(hoursPassed > 0):
		#hoursPassed(hoursPassed)
		pass
	copySeconds=timeOfDay+_seconds
	while floor(copySeconds/(24*60*60))>0:
		currentDay += 1
		copySeconds-= 24*60*60
		
		
	timeOfDay = copySeconds
	emit_signal("time_passed", _seconds)

func processTimeUntil(newseconds):
	if(timeOfDay >= newseconds):			#todo wrap around?
		return
	
	var timeDiff = newseconds - timeOfDay
	
	timeOfDay = newseconds
	doTimeProcess(timeDiff)
	return timeDiff

func startNewDay() ->int:
	#IS.beforeNewDay()
	#GM.CS.optimize()
	
	# We assume that you always go to sleep at 23:00
	if(timeOfDay > getDayTimeEnd()):
		timeOfDay = getDayTimeEnd()
	
	var newtime = getDayTimeStart()
	var timediff = 24 * 60 * 60 - timeOfDay + newtime
	
	#currentDay += 1
	#timeOfDay = newtime
	
	#Flag.resetFlagsOnNewDay()
	#roomMemoriesProcessDay()
	#npcSlaveryOnNewDay()
	
	doTimeProcess(timediff)
	
	#WHS.onNewDay()
	#IS.afterNewDay()
	#SCI.onNewDay()
	#RS.onNewDay()
	
	#SAVE.triggerAutosave()
	
	return timediff

func say():
	pass

#called by save-dialog
func canSave()->bool:
	return true

func saveData()->Dictionary:
	var data={
		"player": Global.player.saveData(),
		"world": Global.world.saveData(),
	}
	return data

func loadData(data: Dictionary):
	Global.player.loadData( data["player"])
	Global.world.loadData( data["world"])
	#scene restoration triggered in Global.loadData


func _on_hud_menu_requested() -> void:
	$WndPause.visible=true
