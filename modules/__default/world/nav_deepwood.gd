extends "res://ui/navigation_scene.gd"

func _init() -> void:
	sceneID="nav_deepwood"

func _on_bt_explore_pressed():
	Global.hud.clearInput()
	Global.main.doTimeProcess(30*60)
	_requiresFatigue(true)
	GR.increaseModuleFlag("Default","Explored_DeepWoods",1)
	if !Global.ES.triggerEvent(EventSystem.TRIGGER.EnterRoom,"nav_deepwoods_explore",[]):
		Global.hud.say("Nothing was found")
		continueScene()

func _requiresFatigue(apply:bool=false):
	return CondCheck.create([CondCheck.Cond_StatChange.create(StatEnum.Fatigue,20)]).check(Global.pc,apply)
