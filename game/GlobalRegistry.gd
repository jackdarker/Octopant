extends Node

# this loads all modules into LUT

var game_version_major = 0
var game_version_minor = 1
var game_version_revision = 0
var game_version_suffix = ""	#"fix1"

signal loadingUpdate(percent, whatsnext)
signal loadingFinished

var flags = {}
var flagsCache = null
var moduleFlags = {}
var moduleFlagsCache = null


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

func clearFlag(flagID):
	var splitData = Util.splitOnFirst(flagID, ".")
	if(splitData.size() > 1):
		clearModuleFlag(splitData[0], splitData[1])
		return
		
	flags.erase(flagID)

func hasFlag(flagID:String) -> bool:
	var splitData = Util.splitOnFirst(flagID, ".")
	if(splitData.size() > 1):
		var modules = GlobalRegistry.getModules()
		var moduleID:String = splitData[0]
		if(!modules.has(moduleID)):
			return false
		var module:Module = modules[moduleID]
		var moduleFlagsCache:Dictionary = module.getFlagsCache()
		if(moduleFlagsCache.has(splitData[1])):
			return true
		return false
		
	if(flagsCache.has(flagID)):
		return true
	return false

func getFlag(flagID, defaultValue = null):
	var splitData = Util.splitOnFirst(flagID, ".")
	if(splitData.size() > 1):
		return getModuleFlag(splitData[0], splitData[1], defaultValue)
	
	
	if(!flagsCache.has(flagID)):
		#Log.printerr("getFlag(): Detected the usage of an unknown flag: "+str(flagID)+" "+Util.getStackFunction())
		return defaultValue
	
	if(!flags.has(flagID)):
		return defaultValue
	
	return flags[flagID]
	
func getModuleFlag(moduleID, flagID, defaultValue = null):
	var modules = GlobalRegistry.getModules()
	if(!modules.has(moduleID)):
		#Log.printerr("getModuleFlag(): Module "+str(moduleID)+" doesn't exist "+Util.getStackFunction())
		return defaultValue
	
	var module:Module = modules[moduleID]
	var moduleFlagsCache = module.getFlagsCache()
	
	if(!moduleFlagsCache.has(flagID)):
		#Log.printerr("getModuleFlag(): Module is "+str(moduleID)+". Detected the usage of an unknown flag: "+str(flagID)+" "+Util.getStackFunction())
		return defaultValue
	
	if(!moduleFlags.has(moduleID) || !moduleFlags[moduleID].has(flagID)):
		return defaultValue
	
	return moduleFlags[moduleID][flagID]

func clearModuleFlag(moduleID, flagID):
	if(!moduleFlags.has(moduleID) || !moduleFlags[moduleID].has(flagID)):
		return
	moduleFlags[moduleID].erase(flagID)
