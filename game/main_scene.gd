extends Node
class_name MainScene

signal time_passed(_secondsPassed)
signal saveLoadingFinished

var actual_scene

func _ready() -> void:
	Global.ui = $Hud	# load("res://ui/hud.tscn").instance()	#GameUI
	goto_scene("res://modules/default/world/nav_beach.tscn")


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
