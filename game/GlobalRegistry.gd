extends Node

# this loads all modules into LUT

var game_version_major = 0
var game_version_minor = 1
var game_version_revision = 0
var game_version_suffix = ""	#"fix1"

signal loadingUpdate(percent, whatsnext)
signal loadingFinished

var modules: Dictionary [String,Module]= {}

var flags = {}
var flagsCache = null
var moduleFlags = {}
var moduleFlagsCache = null

var scenes: Dictionary = {}

var events: Dictionary = {}		#see ES !

var items: Dictionary = {}
var itemsByTag: Dictionary = {}

var effects: Dictionary = {}

var currentUniqueID:int=1
var isInitialized = false

func getGameVersionString():
	return str(game_version_major)+"."+str(game_version_minor)+"."+str(game_version_revision)+str(game_version_suffix)

func generateUniqueID():
	currentUniqueID += 1
	return currentUniqueID - 1

var totalStages = 10.0	#TODO
func registerEverything():
	#createLoadLockFile()
	var start =  Time.get_ticks_usec()
	#loadRegistryCacheFromFile()
	preinitModulesFolder("res://modules/")
	emit_signal("loadingUpdate", 18.0/totalStages, "Modules late initialization")
	#yield(get_tree(), "idle_frame")	await ;is this still required?
	#yield(get_tree(), "idle_frame")
	
	registerModules()
	
	#saveRegistryCacheToFile()
	
	var end = Time.get_ticks_usec()
	var worker_time = (end-start)/1000000.0
	Log.print("GlobalRegistry fully initialized in: %s seconds" % [worker_time])
	isInitialized = true
	#deleteLoadLockFile()
	emit_signal("loadingFinished")

#region save/load
# only need to save flags
func loadData(data):
	currentUniqueID=data["uid"]
	#cleanout all present flags
	var _moduleFlags={}
	#for each loaded module restore saved flags
	#be aware that updated exe might have modules new/missing or have changed structures	
	for moduleid in modules:
		var _moduleDic=data.get_or_add(moduleid,{})
		_moduleFlags[moduleid]=modules[moduleid].postLoadCleanupFlags(_moduleDic)
	moduleFlags=_moduleFlags
	
func saveData()->Variant:
	var data:Dictionary ={
		"uid":currentUniqueID,
	}
	for flagid in flags.keys():	#Todo there could be colliding moduleid with flagid
		data[flagid]=flags[flagid]
	
	for moduleid in moduleFlags.keys():
		var _moduleDic=moduleFlags.get_or_add(moduleid,{})
		for flagid in moduleFlags[moduleid].keys():
			_moduleDic[flagid]=moduleFlags[moduleid][flagid]
		data[moduleid]=_moduleDic
	return(data)
#endregion

#region flags
#TODO there are only Module-flags no general flags?
func clearFlag(flagID):
	var splitData = Util.splitOnFirst(flagID, ".")
	if(splitData.size() > 1):
		clearModuleFlag(splitData[0], splitData[1])
		return
		
	flags.erase(flagID)

func hasFlag(flagID:String) -> bool:
	var splitData = Util.splitOnFirst(flagID, ".")
	if(splitData.size() > 1):
		var _modules = GlobalRegistry.getModules()
		var moduleID:String = splitData[0]
		if(!_modules.has(moduleID)):
			return false
		var module:Module = modules[moduleID]
		var _moduleFlagsCache:Dictionary = module.getFlagsCache()
		if(_moduleFlagsCache.has(splitData[1])):
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

func setFlag(flagID, value):
	# Handling "ModuleID.FlagID" here
	var splitData = Util.splitOnFirst(flagID, ".")
	if(splitData.size() > 1):
		setModuleFlag(splitData[0], splitData[1], value)
		return
	
	# Handling "DatapackID:FlagID" here
	#var splitData2 = Util.splitOnFirst(flagID, ":")
	#if(splitData2.size() > 1):
	#	setDatapackFlag(splitData2[0], splitData2[1], value)
	#	return
	
	if(!flagsCache.has(flagID)):
		Log.printerr("setFlag(): Detected the usage of an unknown flag: "+str(flagID)+" "+Util.getStackFunction())
		return
	
	if("type" in flagsCache[flagID]):
		var flagType = flagsCache[flagID]["type"]
		if(!FlagType.isCorrectType(flagType, value)):
			Log.printerr("setFlag(): Wrong type for flag "+str(flagID)+". Value: "+str(value)+" "+Util.getStackFunction())
			return
			
	flags[flagID] = value

func increaseFlag( flagID, addvalue = 1):
	setFlag( flagID, getFlag( flagID, 0) + addvalue)

func getModuleFlag(moduleID, flagID, defaultValue = null):
	var _modules = GlobalRegistry.getModules()
	if(!_modules.has(moduleID)):
		#Log.printerr("getModuleFlag(): Module "+str(moduleID)+" doesn't exist "+Util.getStackFunction())
		return defaultValue
	
	var module:Module = _modules[moduleID]
	var _moduleFlagsCache = module.getFlagsCache()
	
	if(!_moduleFlagsCache.has(flagID)):
		#Log.printerr("getModuleFlag(): Module is "+str(moduleID)+". Detected the usage of an unknown flag: "+str(flagID)+" "+Util.getStackFunction())
		return defaultValue
	
	if(!moduleFlags.has(moduleID) || !moduleFlags[moduleID].has(flagID)):
		return defaultValue
	
	return moduleFlags[moduleID][flagID]

func setModuleFlag(moduleID, flagID, value):
	var _modules = GlobalRegistry.getModules()
	if(!_modules.has(moduleID)):
		Log.printerr("getModuleFlag(): Module "+str(moduleID)+" doesn't exist "+Util.getStackFunction())
		return
	
	var module:Module = modules[moduleID]
	var moduleFlagsCache = module.getFlagsCache()
	
	if(!moduleFlagsCache.has(flagID)):
		Log.printerr("setModuleFlag(): Module is "+str(moduleID)+". Detected the usage of an unknown flag: "+str(flagID)+" "+Util.getStackFunction())
		return
	
	if("type" in moduleFlagsCache[flagID]):
		var flagType = moduleFlagsCache[flagID]["type"]
		if(!FlagType.isCorrectType(flagType, value)):
			Log.printerr("setModuleFlag(): Module is "+str(moduleID)+". Wrong type for flag "+str(flagID)+". Value: "+str(value)+" "+Util.getStackFunction())
			return
	
	if(!moduleFlags.has(moduleID)):
		moduleFlags[moduleID] = {}
	moduleFlags[moduleID][flagID] = value

func increaseModuleFlag(moduleID, flagID, addvalue = 1):
	setModuleFlag(moduleID, flagID, getModuleFlag(moduleID, flagID, 0) + addvalue)

func clearModuleFlag(moduleID, flagID):
	if(!moduleFlags.has(moduleID) || !moduleFlags[moduleID].has(flagID)):
		return
	moduleFlags[moduleID].erase(flagID)

func resetFlagsOnNewDay():
	for moduleID in modules:
		var moduleObject = modules[moduleID]
		moduleObject.resetFlagsOnNewDay()
		
#endregion


#region modules
func preinitModulesFolder(folder: String):
	var progressBase = 1.0/totalStages
	var progressStep = 2.0/totalStages
	var start = Time.get_ticks_usec()
	
	var moduleFiles: Array = []
	var dir = DirAccess.open(folder)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				var full_path = folder.path_join(file_name)
				#print("FOUND DIR: "+full_path)
				
				var modulePath:String = full_path.path_join("Module.gd")
				if(dir.file_exists(modulePath)):
					moduleFiles.append([file_name, modulePath])
			file_name = dir.get_next()
		var moduleCount = moduleFiles.size()
		var loadedModuleCount = 0
		for moduleFile in moduleFiles:
			var progressValue = progressBase + (progressStep * loadedModuleCount / moduleCount)
			emit_signal("loadingUpdate", progressValue, "Loading " + moduleFile[0])
			#yield(get_tree(), "idle_frame")
			#yield(get_tree(), "idle_frame")
			preInitModule(moduleFile[1])
			loadedModuleCount += 1
	else:
		#Log.printerr("An error occurred when trying to access the path "+folder)
		pass

	var end = Time.get_ticks_usec()
	var worker_time = (end-start)/1000000.0
	#Log.print("MODULES pre-initialized in: %s seconds" % [worker_time])

func registerModules():
	var progressBase = 15.0/totalStages
	var progressStep = 2.0/totalStages
	var moduleCount = modules.size()
	var loadedModuleCount = 0
	for moduleID in modules:
		var moduleObject = modules[moduleID]
		var progressValue = progressBase + (progressStep * loadedModuleCount / moduleCount)
		emit_signal("loadingUpdate", progressValue, moduleObject.id)
		#yield(get_tree(), "idle_frame")
		#yield(get_tree(), "idle_frame")
		
		moduleObject.register()
		print("Module "+moduleObject.id+" by "+moduleObject.author+" was registered")
		loadedModuleCount += 1
		
	postInitModules()

func postInitModules():
	for moduleID in modules:
		var moduleObject = modules[moduleID]
		moduleObject.postInit()

func preInitModule(path: String):
	var module = load(path)
	var moduleObject = module.new()
	moduleObject.preInit()
	modules[moduleObject.id] = moduleObject

func initGameModules():
	for moduleID in modules:
		var moduleObject = modules[moduleID]
		moduleObject.initGame()

func getModules()->Dictionary:
	return modules

func getModule(id):
	if(!modules.has(id)):
		#Log.printerr("ERROR: module with the id "+id+" wasn't found")
		return null
	return modules[id]
#endregion

#region events
func registerEvent(path: String):
	#-------------------------------------------------------------------
	#if path is dir, import dir
	if(DirAccess.dir_exists_absolute(path)):
		for file in DirAccess.get_files_at(path):
			if file.get_extension().to_lower()=="gd":
				registerEvent(path.path_join(file))
		return
	#-------------------------------------------------------------------
	var item = load(path)
	var itemObject = item.new()
	events[itemObject.id] = itemObject

		
func getEvent(id: String):
	if(!events.has(id)):
		Log.printerr("ERROR: event with the id "+id+" wasn't found")
		return null
	return events[id]

func getEvents():
	return events
	
#endregion

#region scenes
#path is file or directory
func registerScene(path: String, creator = null):
	#if(hasCachedPath(CACHE_SCENE, path)):
	#	scenes[getCachedID(CACHE_SCENE, path)] = null
	#	return
	#-------------------------------------------------------------------
	#if path is dir, import dir
	if(DirAccess.dir_exists_absolute(path)):
		for file in DirAccess.get_files_at(path):
			if file.get_extension().to_lower()=="tscn":
				registerScene(path.path_join(file))
		return
	#-------------------------------------------------------------------
	path.get_file()
	
	var scene = load(path)
	if(!scene):
		#Log.printerr("ERROR: couldn't load scene from path "+path)
		return
	var sceneObject = scene.instantiate()
	scenes[sceneObject.sceneID] = scene
	#addCacheEntry(CACHE_SCENE, sceneObject.sceneID, path)
	sceneObject.queue_free()
	
func createScene(id: String):
	if(!scenes.has(id) ):
		Log.printerr("ERROR: scene with the id "+id+" wasn't found")
		return null
	var scene
	scene = scenes[id].instantiate()
	scene.name = scene.sceneID
	scene.uniqueSceneID = generateUniqueID()
	return scene
	
#endregion

#region Items
#path is file or directory
func registerItem(path: String):
	#-------------------------------------------------------------------
	#if path is dir, import dir
	if(DirAccess.dir_exists_absolute(path)):
		for file in DirAccess.get_files_at(path):
			if file.get_extension().to_lower()=="gd":
				registerItem(path.path_join(file))
		return
	#-------------------------------------------------------------------
	var item = load(path)
	var itemObject = item.new()
	items[itemObject.id] = item
	for tag in itemObject.getTags():
		if(!itemsByTag.has(tag)):
			itemsByTag[tag] = []
		itemsByTag[tag].append(itemObject.id)

func createItem(id: String)->ItemBase:
	if(!items.has(id)):
		Log.printerr("ERROR: item with the id "+id+" wasn't found")
		return null
	var newItem = items[id].new()
	return newItem
#endregion

#region effects
func registerEffect(path: String):
	#-------------------------------------------------------------------
	#if path is dir, import dir
	if(DirAccess.dir_exists_absolute(path)):
		for file in DirAccess.get_files_at(path):
			if file.get_extension().to_lower()=="gd":
				registerEffect(path.path_join(file))
		return
	#-------------------------------------------------------------------
	var item = load(path)
	var itemObject = item.new()
	effects[itemObject.ID] = item


func createEffect(id: String)->Effect:
	if(!effects.has(id)):
		Log.printerr("ERROR: effect with the id "+id+" wasn't found")
		return null
	var newItem = effects[id].new()
	return newItem
	
#endregion
