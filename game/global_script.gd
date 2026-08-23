extends Node

var hud: Hud
var toolTip:TooltipSystem
var main: MainScene
var pc: Player
var World: GameWorld
var ES: EventSystem
var QS: QuestSystem
var Setup:Settings

var current_scene = null
@warning_ignore("unused_signal")
signal npc_defeated(npc:Character)	#triggered when mob is defeated in combat
@warning_ignore("unused_signal")
signal npc_talked(npcID:String,themeID:String)	#triggered when player talked to NPC about something

func _ready() -> void:
	#directory.make_dir("user://mods")
	var root = get_tree().root
	# Using a negative index counts from the end, so this gets the last child node of `root`.
	current_scene = root.get_child(-1)
	Setup = Settings.new()

func quitGodot():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()

## if data!=null, it will call loaddata (used for restoring gamestate)
## if path is main_scene, it will init the game (called only once at game startup)
func goto_scene(path,data=null):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:
	_deferred_goto_scene.call_deferred(path,data)


func _deferred_goto_scene(path,data):
	# It is now safe to remove the current scene.
	current_scene.free()
	# Load the new scene.
	var s = ResourceLoader.load(path)
	# Instance the new scene.
	current_scene = s.instantiate()
	# Add it to the active scene, as child of root.
	get_tree().root.add_child(current_scene)
	# Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
	get_tree().current_scene = current_scene
	if(data!=null):
		loadData(data)
	elif(path=="res://game/main_scene.tscn"):
		current_scene.runScene("nav_beach")	#TODO intro   

#region save/load
var SAVE_DIR="user://save/"
var SETTING_FILE="user://setting"	
#located in C:\Users\xxx\AppData\Roaming\Godot\app_userdata\THE_APP
# it is assumed the filename looks like: yyyy_mm_dd_hhmmss.save
#  Time.get_datetime_string_from_system(true,false)


func newSaveFileName()->String:
	var _newfile=(Time.get_datetime_string_from_system(true,true)+".save").replace(":","")
	return _newfile
	
var saves_info:Array = []	#this holds data for save-UI so that we dont need to parse all files if it updates
func getAllSaves()->Array:
	saves_info = []
	DirAccess.make_dir_absolute(SAVE_DIR)
	var dir = DirAccess.open(SAVE_DIR)
	if(!dir):
		return saves_info
	
	var _files=DirAccess.get_files_at(SAVE_DIR)  #alphabetical sorted
	for _file in _files:
		if(_file.get_extension()=="save"):
			var data = loadFromFileRaw(SAVE_DIR.path_join(_file))
			if(data):
				saves_info.push_back({"file":_file,"info":data.main.info})
	return saves_info

func deleteSaveFile(slot):
	DirAccess.remove_absolute(SAVE_DIR.path_join(slot))

var compress_save:=false
func saveToFileRaw(path,saveData):
	if(compress_save):
		var writer = ZIPPacker.new()
		var err = writer.open(path)
		if err != OK:
			return err	#TODO?
		writer.start_file("save")
		writer.write_file(JSON.stringify(saveData).to_utf8_buffer())
		writer.close_file()
	else:
		var save_game=FileAccess.open(path, FileAccess.WRITE)
		save_game.store_string(JSON.stringify(saveData))
		save_game.close()
		
func saveToFile(slot):
	var _path=SAVE_DIR.path_join(slot)
	var _saveData = saveData()
	saveToFileRaw(_path,_saveData)

## loads savegame-data from a file
func loadFromFileRaw(path)->Variant:
	if not FileAccess.file_exists(path):
		return null # Error! We don't have a save to load.
	var json=JSON.new()
	var jsonResult
	var save_game
	if(compress_save):
		var reader = ZIPReader.new()
		var err = reader.open(path)
		if err != OK:
			return PackedByteArray()
		save_game = reader.read_file("save")
		reader.close()
		jsonResult = json.parse(save_game.get_string_from_utf8())
	else:
		save_game=FileAccess.open(path, FileAccess.READ)
		jsonResult = json.parse(save_game.get_as_text())
		save_game.close()
	if(jsonResult != OK):
		assert(false, "Trying to load a bad save file "+str(path))
		return null
	return json.data

## triggers fileloading and switching to scene
func loadFromFile(slot):
	var _path=SAVE_DIR.path_join(slot)
	var data = loadFromFileRaw(_path)
	Global.goto_scene("res://game/main_scene.tscn",data)

## initializes all game-object with the loaded data and triggers postLoad
func loadData(data):
	#TODO Global.settings.loadData(data.settings)		store settings in separate file?
	#Note: data["info"] used by save-UI !
	Global.main.beforeLoad()
	GR.loadData(data.globalregistry)
	Global.main.loadData(data.main)
	Global.pc.loadData(data.pc)
	Global.QS.loadData(data["quests"]) #done after characters because checking inventory!
	Tutorials.loadData(data.tutorials)
	loadDataTree(data.nodes)
	Global.main.postLoad()


## restore nodes ; existing Prsist-Nodes will be deleted before!
# only plain attributes can be restored; you have to implement some restore by adding property-setter (se pickup.gd)
func loadDataTree(nodes_data):
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		if(i):	#nodes might be already null because they are subnodes of already deleted nodes
			i.free()
		#await i.tree_exited
	for data in nodes_data:
		# Firstly, we need to create the object and add it to the tree and set its position.
		var new_object = load(data["scene"]).instantiate()
		get_node(data["parent"]).add_child(new_object)
		new_object.position = Vector2(data["pos_X"], data["pos_Y"])

		# Now we set the remaining variables.
		for i in data.keys():
			if i == "filename" or i=="scene" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			new_object.set(i, data[i])
		new_object.postLoad()

## calls saveData() on all games objects to extract data
func saveData()->Variant:
	var data ={
		"globalregistry":GR.saveData(),
		"main":Global.main.saveData(),
		"pc": Global.pc.saveData(),
		"quests":Global.QS.saveData(),
		"tutorials":Tutorials.saveData(),
		"nodes":saveDataTree()
	}
	
	return(data)

## walks the node-tree and extracts data from "Persist" nodes by calling saveData
func saveDataTree()->Variant:
	var data:Array[Dictionary]=[]
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue
		# Check the node has a save function.
		if !node.has_method("saveData"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue
		# Call the node's save function.
		data.push_back(node.call("saveData"))
	return data

## note: all games share same settings-file
func loadSettings():
	var data = loadFromFileRaw(SETTING_FILE)
	Setup.reset()
	if(data):	#there might be no file yet 
		Setup.loadData(data)

func saveSettings():
	saveToFileRaw(SETTING_FILE,Setup.saveData())
	
#endregion
