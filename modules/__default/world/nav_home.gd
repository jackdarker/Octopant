extends "res://ui/navigation_scene.gd"

func _init() -> void:
	sceneID="nav_home"

func enterScene2():
	#super()
	set_bg(load("res://assets/images/bg/nav_home_sun.png"))
	Global.hud.addButton("go somewhere else...","",_on_bt_walk_pressed)
	Global.hud.addButton("craft...","",_on_bt_craft_pressed)
	Global.hud.addButton("sleep until morning","",_on_bt_sleep_pressed)
	pass

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
	
func OBSOLETE_on_bt_craft_pressed() -> void:
	Global.hud.clearInput()
	Global.main.doTimeProcess(120*60)
	Global.hud.say("You rummage through your collection of sticks and stones but have no idea how to connect them together.")
	Global.pc.inventory.addItem(GR.createItem("knife_seashell"))
	continueScene()
