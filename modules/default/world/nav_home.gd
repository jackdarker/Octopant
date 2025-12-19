extends "res://ui/navigation_scene.gd"

func _init() -> void:
	sceneID="nav_home"


func _on_bt_explore_pressed() -> void:
	Global.main.goto_scene("res://modules/default/world/nav_beach.tscn")


func _on_bt_sleep_pressed() -> void:
	Global.main.startNewDay()
	pass # Replace with function body.
