extends "res://ui/navigation_scene.gd"

func _init() -> void:
	sceneID="nav_home"

func canSave()->bool:
	return true

func _on_bt_walk_pressed():
	Global.hud.clearInput()
	Global.hud.say("Where would you like to go?")
	Global.hud.addButton("back","",enterScene)
	Global.hud.addButton("Beach","",Global.main.runScene.bind("nav_beach"))
	if(GR.getModuleFlag("Default","Found_Cliff",0)>0):
		Global.hud.addButton("Cliff","",Global.main.runScene.bind("nav_cliff"))


func _on_bt_sleep_pressed() -> void:
	Global.main.gotoSleep()

func _on_bt_craft_pressed() -> void:
	Global.main._on_hud_crafting_requested(Global.pc,"Backpack")
	
