extends Node

# this loads all modules into LUT

var game_version_major = 0
var game_version_minor = 1
var game_version_revision = 0
var game_version_suffix = ""	#"fix1"

signal loadingUpdate(percent, whatsnext)
signal loadingFinished

var currentUniqueID:int=1
var isInitialized = false

func _init():
	pass

func getGameVersionString():
	return str(game_version_major)+"."+str(game_version_minor)+"."+str(game_version_revision)+str(game_version_suffix)

func generateUniqueID():
	currentUniqueID += 1
	return currentUniqueID - 1

func registerEverything():
	#createLoadLockFile()
	var start =  Time.get_ticks_usec()
	var totalStages = 5.0
	#loadRegistryCacheFromFile()
	emit_signal("loadingUpdate", 18.0/totalStages, "Modules late initialization")
	#yield(get_tree(), "idle_frame")	await ;is this still required?
	#yield(get_tree(), "idle_frame")

	
	#saveRegistryCacheToFile()
	
	var end = Time.get_ticks_usec()
	var worker_time = (end-start)/1000000.0
	#Log.print("GlobalRegistry fully initialized in: %s seconds" % [worker_time])
	isInitialized = true
	#deleteLoadLockFile()
	emit_signal("loadingFinished")
