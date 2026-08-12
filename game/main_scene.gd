class_name MainScene extends Node

# the MAIN-scene of the game that holds references to the actual story-scene and windows

signal time_passed(_secondsPassed)
signal item_trade(giverId:String,receiverId:String,itemid:String,amount:int)	#used by queststep_deliver_item

const TIME_STEP=300	#a single slot is 5min

var sceneStack:Array=[]
var currentSceneUID:int:
	get():
		return -1 if !getCurrentScene() else getCurrentScene(). uniqueSceneID
			
var currentDay = 0
var timeOfDay:int = 6*60*60 # seconds since 00:00

func _ready() -> void:
	Global.hud = $Hud
	Global.toolTip=$TooltipSystem
	Global.main = self
	Global.ES = EventSystem.new()
	Global.QS =  QuestSystem.new()
	Global.pc = Player.new()
	Global.World = $GameWorld
	$WndInventory.character=Global.pc	#TODO what if need to modify other character?
	
	Global.ES.registerEventTriggers()
	# connect events from UI & logic
	Global.QS.quest_accepted.connect(func(quest): Global.toolTip.showNotification("Quest started",quest.quest_name))
	Global.QS.quest_completed.connect(func(quest): Global.toolTip.showNotification("Quest completed",quest.quest_name,load("res://assets/images/icons/ic_unknown.svg")))
	Global.QS.quest_updated.connect(func(quest): Global.toolTip.showNotification("Quest updated",quest.quest_name))
	time_passed.connect(Global.hud.processTime)
	time_passed.connect(Global.World.processTime)
	Global.hud.map_requested.connect(func(): $WndMap.visible=true)
	Global.hud.setup_requested.connect(func(): $WndSettings.visible=true)
	Global.hud.log_requested.connect(func(): $WndQuest.visible=true)
	Global.hud.inventory_requested.connect(func(): $WndInventory.visible=true)
	Global.hud.status_requested.connect(func(): $WndStatus.visible=true)
	Global.hud.menu_requested.connect(func(): $WndPause.visible=true)
	
	Global.hud.inv.set_character(Global.pc)
	Global.hud.outfit.outfit=true
	Global.hud.outfit.set_character(Global.pc)
	Global.hud.map.assignWorld()
	Global.pc.outfit.addItem(GR.createItem("shirt_plain"))
	Global.pc.outfit.addItem(GR.createItem("shorts_plain"))
	postLoad()

#region scene
func runScene(ID:String, _args = [], parentSceneUniqueID = -1):
	defferedRunScene.call_deferred(ID,_args, parentSceneUniqueID )


func defferedRunScene(ID:String, _args = [], parentSceneUniqueID = -1):
	var actual_scene:DefaultScene = getCurrentScene()
	if(actual_scene && parentSceneUniqueID!=actual_scene.uniqueSceneID):
		sceneStack.erase(actual_scene)
		actual_scene.free()
	# Load the new scene.
	Log.verbose("Starting scene "+ID)
	#var s = ResourceLoader.load(path)
	if(ID=="interaction_scene"):
		#Global.hud.visible=false
		actual_scene=load("res://ui/interaction_scene.tscn").instantiate()
		actual_scene.dialogue_gdscript=_args[0]
		actual_scene.back_image=_args[1]
		actual_scene.args=_args.slice(2)
		actual_scene.setupScene()
	elif(ID=="combat_scene"):
		actual_scene=load("res://ui/combat_scene.tscn").instantiate()
		actual_scene.setupScene(_args[0])
	else:
		Global.hud.hudMode=Hud.HUDMODE.Explore
		actual_scene = GR.createScene(ID)
		actual_scene.setupScene()
	if(parentSceneUniqueID >= 0):
		actual_scene.parentSceneUniqueID = parentSceneUniqueID
	# Add it to the active scene, as child of root.
	sceneStack.append(actual_scene)
	get_node("Scene").add_child(actual_scene)
	

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
		Log.verbose("Error: no more scenes in the scenestack")
		Global.hud.clearInput()
		Global.hud.say("Error: no more scenes in the scenestack. Please let the developer know")
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

func playerSpecialScene()->bool:
	#TODO here we can place checks to visualize state change of player
	#this is called when starting a usual nav_scene and injects a proper visual scene
	#afterwards it returns to the nav_scene again. This could trigger another visual scene and cause a loop!
	var _ret:bool=false
	_ret=Global.ES.triggerEvent(EventSystem.TRIGGER.InRoom,"",[])		
	return _ret

#endregion

#region Time

## time since start in seconds
func getTime()->int:
	return timeOfDay+currentDay*24*60*60

## in seconds
func getDayTime()->int:
	return timeOfDay

## returns days in game
func getDays()->int:
	return currentDay

func getDayTimeEnd()->int:
	return 23 * 60 * 60
	
func getDayTimeStart()->int:
	return 7 * 60 * 60

func isVeryLate()->bool:
	return timeOfDay >= getDayTimeEnd()



func doTimeProcess(_seconds:int):
	# This splits long timespans into chunks	
	var copySeconds:= _seconds
	var copyDaytime:int=timeOfDay
	var dayTmp:int
	while(copySeconds > 0):
		var clippedSeconds = min(TIME_STEP, copySeconds)
		copyDaytime+=clippedSeconds
		dayTmp = copyDaytime-(24*60*60)
		if(dayTmp>0):	#new day
			currentDay += 1
			copyDaytime=dayTmp
			timeOfDay=dayTmp
		else:
			timeOfDay+=clippedSeconds
		Global.pc.processTime(clippedSeconds)
		
		#for characterID in charactersToUpdate:
		#	var character = getCharacter(characterID)
		#	if(character != null):
		#		character.processTime(clippedSeconds)
		time_passed.emit(clippedSeconds)
		copySeconds -= clippedSeconds
		
	Global.main.checkForGameOver()	#TODO here?

func startNewDay():
	#IS.beforeNewDay()
	#GM.CS.optimize()
	
	# We assume that you always go to sleep at 23:00
	if(timeOfDay > getDayTimeEnd()):
		timeOfDay = getDayTimeEnd()				#TODO this causes to wakeup later !
	
	var newtime = getDayTimeStart()
	var timediff = 24 * 60 * 60 - timeOfDay + newtime
	
	GR.resetFlagsOnNewDay()
	#roomMemoriesProcessDay()
	#npcSlaveryOnNewDay()
	
	doTimeProcess(timediff)
	
	#WHS.onNewDay()
	#IS.afterNewDay()
	#SCI.onNewDay()
	#RS.onNewDay()
	
	#SAVE.triggerAutosave()

func gotoSleep():
	await Global.hud.fade()	#wait for fade out  #TODO fadeout  do stuff fadein
	#TODO sleep event
	startNewDay()
	Global.pc.post_sleep()

#endregion

func defaultDefeat(_scene):
	Global.main.clearSceneStack()	
	Global.pc.getStat(StatEnum.Pain).modify(-9) # lower pain or it triggers defeat again
	Global.main.runScene("nav_home")
			
func defaultGameOver(_scene):
	Global.main.clearSceneStack()
	Global.main.runScene("nav_gameover")

			
# call this in scenes to check and handle game over state
func checkForGameOver():
	var _n =Global.pc.getStat(StatEnum.Pain)
	if _n.atUL:		#Pain -> game over
		defaultGameOver(Global.main.getCurrentScene())
		
	_n =Global.pc.getStat(StatEnum.Insanity)
	if _n.atUL || _n.atLL:	#Sanity -> Game over
		defaultGameOver(Global.main.getCurrentScene())
		
	#TODO ? _n =Global.pc.getStat(StatEnum.Fatigue)
	#if _n.atUL:		#Pass out -> Teleport
	#	defaultDefeat(Global.main.getCurrentScene())

#region save/load
#called by save-dialog
func canSave()->bool:
	var _scene=getCurrentScene()
	if(_scene && _scene.has_method("canSave")):
		return _scene.canSave()
	return true
	
func loadData(data):
	timeOfDay=data["time"]
	currentDay=data["day"]
	var _scenes:Dictionary=data["scenes"]
	for _scene in sceneStack:
		_scene.queue_free()
	for _id in _scenes.keys():
		var _scene=GR.createScene(_id)
		_scene.loadData(_scenes[_id])
		_scene.setupScene()
		sceneStack.push_back(_scene)
		get_node("Scene").add_child(_scene)
	getCurrentScene().enterScene()
			
func saveData()->Variant:
	#Note: data["info"] used by save-UI !
	var _scenes:={}
	for _scene in sceneStack:
		if !_scene.canSave():
			Log.error("tried to save scene that has no save-support: "+str(_scene.uniqueSceneID))
		_scenes[_scene.sceneID]=_scene.saveData()
		
	var data ={
		"info": Global.pc.location+" ,day "+str(getDays()) + " "+ Util.getTimeStringHHMM(getDayTime()),
		"day":currentDay,
		"time": timeOfDay,
		"scenes": _scenes,
	}

	return(data)

func beforeLoad():
	# to not spam signal when inventory items are re-added
	for evt in Global.pc.inventory.item_added.get_connections():
		evt.signal.disconnect(evt.callable)
	for evt in Global.pc.inventory.item_removed.get_connections():
		evt.signal.disconnect(evt.callable)

func postLoad():
	# because stats are recreated on load, events also need to be reconnected
	Global.pc.status.registerSignalItemChanged(Global.hud.on_pc_stat_update,"pain")		
	Global.pc.status.registerSignalItemChanged(Global.hud.on_pc_stat_update,"fatigue")
	Global.pc.status.registerSignalItemChanged(Global.hud.on_pc_stat_update,StatEnum.Lust)
	Global.pc.status.registerSignalItemChanged(Global.hud.on_pc_stat_update,StatEnum.Insanity)
	Global.pc.effects.registerSignalItemsChanged(Global.hud.on_pc_effect_update)
	Global.pc.inventory.item_added.connect(func(itemID): Global.toolTip.showNotification("Item added",itemID))
	Global.pc.inventory.item_removed.connect(func(itemID): Global.toolTip.showNotification("Item removed",itemID))
	
	Global.World.setupMaps()
		#TODO force update HUD, also restore the running event ?
	time_passed.emit(0)
	Global.hud.on_pc_stat_update.call_deferred("pain",0)	#todo Global.pc.effects.forceUpdate()
	addDebugCmds() # add debug-commands TODO is this correct place?

	var roomID=Global.pc.location #map_mansion@room 3
	if(roomID.rsplit("@").size()>1):
		Global.pc.location=""	#hack: onEnter triggers only if char is NOT already there
		Global.World.getRoomByID(roomID)._onEnter()

func addDebugCmds():
	DbgConsole.addCommand("getversion",GR,"getGameVersionString",[],["version"],"")
	DbgConsole.addCommand("getmodules",GR,"getModuleIDs",[],["IDs"],"loaded modules")
	DbgConsole.addCommand("getitems",GR,"getItemIDs",[],["IDs"],"available items")
	DbgConsole.addCommand("pcadditem",Global.pc.inventory,"addItemID",["itemID"],[],"add item to player")
	DbgConsole.addCommand("setflag",GR,"setModuleFlag",["moduleID","flagID","value"],[],"sets a flag")
	DbgConsole.addCommand("setflagint",GR,"setModuleFlag",["moduleID","flagID","value:int"],[],"sets a NUMERIC flag")
	DbgConsole.addCommand("getflag",GR,"getModuleFlag",["moduleID","flagID"],["value"],"gets a flag")
	#combat encounter
	#force quest 
	#teleport location
	#trigger interaction	
	
#endregion

func _on_hud_crafting_requested(character:Character,type:String) -> void:
	$WndCraft.character=character
	$WndCraft.craftStation=type
	$WndCraft.visible=true
