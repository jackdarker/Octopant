extends "res://ui/navigation_scene.gd"

func _init() -> void:
	sceneID="nav_home"

func canSave()->bool:
	return true

func _on_bt_sleep_pressed() -> void:
	Global.main.gotoSleep()

func _start_run(where:String):
	GR.setModuleFlag("Default","Dungeon_Name",where)
	GR.setModuleFlag("Default","Dungeon_RoomsExplored",{})
	GR.setModuleFlag("Default","BossKilled",0)
	GR.setModuleFlag("Default","SP_EarnedRun",0)
	GR.setModuleFlag("Default","RoomsExplored",0)
	Global.main.runScene(where)

func _on_bt_craft_pressed() -> void:
	#Global.main._on_hud_crafting_requested(Global.pc,"Backpack")
	pass
