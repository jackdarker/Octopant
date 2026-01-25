extends Node

var ui: GameUI
var toolTip:CanvasLayer
var main: MainScene
var pc: Player
var world: GameWorld
var ES: EventSystem
var QS: QuestSystem

var current_scene = null

func _ready() -> void:
	#directory.make_dir("user://mods")
	
	var root = get_tree().root
	# Using a negative index counts from the end, so this gets the last child node of `root`.
	current_scene = root.get_child(-1)

func quitGodot():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()

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

#region save/load
var SAVE_DIR="user://Save/"	
#located in C:\Users\xxx\AppData\Roaming\Godot\app_userdata\THE_APP
# it is assumed the filename looks like: yyyy_mm_dd_hhmmss.save
#  Time.get_datetime_string_from_system(true,false)

var saves_info:Array = []
func newSaveFileName()->String:
	var _newfile=(Time.get_datetime_string_from_system(true,true)+".save").replace(":","")
	return _newfile
	
	
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

func saveToFile(slot):
	var _path=SAVE_DIR.path_join(slot)
	var _saveData = saveData()
	var save_game=FileAccess.open(_path, FileAccess.WRITE)
	save_game.store_string(JSON.stringify(_saveData))
	save_game.close()

func loadFromFileRaw(path)->Variant:
	if not FileAccess.file_exists(path):
		#Log.error("Save file is not found in "+str(_path))
		#assert(false, "Save file is not found in "+str(_path))
		return # Error! We don't have a save to load.
	
	var save_game=FileAccess.open(path, FileAccess.READ)
	#var saveData = parse_json(save_game.get_as_text())
	var json=JSON.new()
	var jsonResult = json.parse(save_game.get_as_text())
	if(jsonResult != OK):
		assert(false, "Trying to load a bad save file "+str(path))
		return null
	save_game.close()
	return json.data
		
func loadFromFile(slot):
	var _path=SAVE_DIR.path_join(slot)
	var data = loadFromFileRaw(_path)
	Global.goto_scene("res://game/main_scene.tscn",data)

func loadData(data):
	#TODO Global.settings.loadData(data.settings)		store settings in separate file?
	#Note: data["info"] used by save-UI !
	GlobalRegistry.loadData(data.globalregistry)
	Global.main.loadData(data.main)
	Global.pc.loadData(data.pc)
	Global.main.postLoad()
			
func saveData()->Variant:
	var data ={
		"globalregistry":GlobalRegistry.saveData(),
		"main":Global.main.saveData(),
		"pc": Global.pc.saveData(),
	}
		
	return(data)

#endregion
