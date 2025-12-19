extends Node
class_name MainScene

signal time_passed(_secondsPassed)
signal saveLoadingFinished

var actual_scene
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
	
	goto_scene("res://modules/default/world/nav_beach.tscn")	#todo intro


func goto_scene(path):
	_deferred_goto_scene.call_deferred(path)


func _deferred_goto_scene(path):
	# It is now safe to remove the current scene.
	if(actual_scene):
		actual_scene.free()
	# Load the new scene.
	var s = ResourceLoader.load(path)
	# Instance the new scene.
	actual_scene = s.instantiate()
	# Add it to the active scene, as child of root.
	get_node("Scene").add_child(actual_scene)

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
