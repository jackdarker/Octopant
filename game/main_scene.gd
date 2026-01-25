extends Node
class_name MainScene

signal time_passed(_secondsPassed)

var sceneStack:Array=[]

var currentDay = 0
var timeOfDay:int = 6*60*60 # seconds since 00:00

func _ready() -> void:
	Global.ui = $Hud
	Global.toolTip=$TooltipSystem
	Global.main = self
	Global.ES = EventSystem.new()
	Global.pc = Player.new()
	$WndInventory.character=Global.pc
	
	Global.ES.registerEventTriggers()
	time_passed.connect(Global.ui.on_time_passed)
	postLoad()
	#todo intro
	runScene("nav_beach")

func runScene(ID, _args = [], parentSceneUniqueID = -1):
	defferedRunScene.call_deferred(ID,_args, parentSceneUniqueID )

func defferedRunScene(ID, _args = [], parentSceneUniqueID = -1):
	var actual_scene = getCurrentScene()
	if(actual_scene && parentSceneUniqueID!=actual_scene.uniqueSceneID):
		sceneStack.erase(actual_scene)
		actual_scene.free()
	# Load the new scene.
	print("Starting scene "+ID)
	#var s = ResourceLoader.load(path)
	if(ID=="interaction_scene"):
		Global.ui.visible=false
		actual_scene=load("res://ui/interaction_scene.tscn").instantiate()
		actual_scene.dialogue_gdscript=_args[0]
		actual_scene.back_image=_args[1]
	else:
		actual_scene = GlobalRegistry.createScene(ID)
	if(parentSceneUniqueID >= 0):
		actual_scene.parentSceneUniqueID = parentSceneUniqueID
	# Add it to the active scene, as child of root.
	get_node("Scene").add_child(actual_scene)
	sceneStack.append(actual_scene)

func removeScene(scene, args = []):
	defferedRemoveScene.call_deferred(scene,args)
	
func defferedRemoveScene(scene, args = []):
	if(sceneStack.has(scene)):
		#var isCurrentScene = (scene == sceneStack.back())
		var savedParentSceneID = scene.parentSceneUniqueID
		var savedTag = [] #todo scene.sceneTag
		
		sceneStack.erase(scene)
		scene.queue_free()
		var parentScene = getSceneByUniqueID(savedParentSceneID)
		if(parentScene != null):
			parentScene.react_scene_end(savedTag, args)
			parentScene.enterScene()
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

func getTime()->int:
	return timeOfDay

func getDayTimeEnd()->int:
	return 23 * 60 * 60
	
func getDayTimeStart()->int:
	return 7 * 60 * 60

func isVeryLate()->bool:
	return timeOfDay >= getDayTimeEnd()

func getDays()->int:
	return currentDay

func doTimeProcess(_seconds:int):
	# This splits long sleeping times into 1 hour chunks	
	var copySeconds = _seconds
	while(copySeconds > 0):
		var clippedSeconds = min(60*60, copySeconds)
		Global.pc.processTime(clippedSeconds)
		
		#for characterID in charactersToUpdate:
		#	var character = getCharacter(characterID)
		#	if(character != null):
		#		character.processTime(clippedSeconds)
		
		
		copySeconds -= clippedSeconds
	
	@warning_ignore("integer_division")
	var oldHours = floor((timeOfDay - _seconds) / 3600)
	@warning_ignore("integer_division")
	var newHours = floor(timeOfDay / 3600)
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

func startNewDay():
	#IS.beforeNewDay()
	#GM.CS.optimize()
	
	# We assume that you always go to sleep at 23:00
	if(timeOfDay > getDayTimeEnd()):
		timeOfDay = getDayTimeEnd()				#TODO this causes to wakeup later !
	
	var newtime = getDayTimeStart()
	var timediff = 24 * 60 * 60 - timeOfDay + newtime
	
	#Flag.resetFlagsOnNewDay()
	#roomMemoriesProcessDay()
	#npcSlaveryOnNewDay()
	
	doTimeProcess(timediff)
	
	#WHS.onNewDay()
	#IS.afterNewDay()
	#SCI.onNewDay()
	#RS.onNewDay()
	
	#SAVE.triggerAutosave()

func gotoSleep():
	Global.ui.fade()
	#TODO sleep event
	startNewDay()
	Global.pc.post_sleep()

#called by save-dialog
func canSave()->bool:
	return true

#region save/load
func loadData(data):
	timeOfDay=data["time"]
	currentDay=data["day"]
			
func saveData()->Variant:
	#Note: data["info"] used by save-UI !
	var data ={
		"info": Global.pc.location+" ,day "+str(getDays()) + " "+ Util.getTimeStringHHMM(getTime()),
		"day":currentDay,
		"time": timeOfDay,
	}
	return(data)
	
func postLoad():
	# because stats are recreated on load, events also need to be reconnected
	Global.pc.statuslist.registerSignalItemChanged(Global.ui.on_pc_stat_update,"pain")		
	Global.pc.statuslist.registerSignalItemChanged(Global.ui.on_pc_stat_update,"fatigue")
	Global.pc.statuslist.registerSignalItemChanged(Global.ui.on_pc_stat_update,StatEnum.Lust)
	Global.pc.effectlist.registerSignalItemsChanged(Global.ui.on_pc_effect_update)
	#TODO force update HUD, also restore the running event ?
	time_passed.emit(0)
	Global.ui.on_pc_stat_update("pain",0)	#todo Global.pc.effectList.forceUpdate()
	
#endregion
func _on_hud_menu_requested() -> void:
	$WndPause.visible=true

func _on_hud_inventory_requested() -> void:
	$WndInventory.visible=true
