extends Node

var ui: GameUI
var main: MainScene
var pc: Player
var world: GameWorld
var ES: EventSystem
var QS: QuestSystem

var current_scene = null

func _ready() -> void:
	#var directory = Directory.new()		TODO
	#directory.make_dir("user://saves")
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

#region settings
var SAVE_FILE="user://Savegame_"	
#located in C:\Users\xxx\AppData\Roaming\Godot\app_userdata\BilderalbumGD

func saveToFile(slot):
	var _path=SAVE_FILE+str(slot)
	var saveData = saveData()
	var save_game=FileAccess.open(_path, FileAccess.WRITE)
	save_game.store_string(JSON.stringify(saveData))
	save_game.close()
	
func loadFromFile(slot):
	var _path=SAVE_FILE+str(slot)
	if not FileAccess.file_exists(_path):
		#Log.error("Save file is not found in "+str(_path))
		#assert(false, "Save file is not found in "+str(_path))
		return # Error! We don't have a save to load.
	
	var save_game=FileAccess.open(_path, FileAccess.READ)
	#var saveData = parse_json(save_game.get_as_text())
	var json=JSON.new()
	var jsonResult = json.parse(save_game.get_as_text())
	if(jsonResult != OK):
		assert(false, "Trying to load a bad save file "+str(_path))
		return
	
	save_game.close()
	Global.goto_scene("res://game/main_scene.tscn",json.data)

func loadData(data):
	#TODO Global.settings.loadData(data.settings)		store settings in separate file?
	GlobalRegistry.loadData(data.globalregistry)
	Global.pc.loadData(data.pc)
	Global.main.postLoad()
			
func saveData()->Variant:
	var data ={
		"globalregistry":GlobalRegistry.saveData(),
		"pc": Global.pc.saveData(),
	}
		
	return(data)

#endregion
