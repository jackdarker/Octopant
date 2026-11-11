extends SceneExtension

const sceneID="nav_home"

func on_enterScene():
	parent_scene.set_bg(load("res://assets/images/bg/nav_home_sun.png"))
	Global.hud.say("A safe room.")

func get_buttons(menuid:String,buttons:Array):
	if(menuid==""):
		buttons.push_back(Button_Config.new("go somewhere else...","",parent_scene.menu.bind("walk")))
		buttons.push_back(Button_Config.new("upgrades...","",parent_scene.menu.bind("upgrades")))
		#buttons.push_back(Button_Config.new("craft...","",parent_scene._on_bt_craft_pressed))
		#buttons.push_back(Button_Config.new("sleep until morning","",parent_scene._on_bt_sleep_pressed))
	if(menuid=="walk"):
		Global.hud.say("Where would you like to go?")
		#if(GR.getModuleFlag("Default","Found_Beach",0)>0):
		buttons.push_back(Button_Config.new("Mysterious cave","",parent_scene.menu.bind("Dungeon Level1")))
		#buttons.push_back(Button_Config.new("debug","",Global.main.runScene.bind("nav_debug")))
	if(menuid=="Dungeon Level1"):
		Global.hud.clearOutput()
		Global.hud.say("[b]Mysterious cave[/b]")
		Global.hud.say("A system of caves with lurking dangers in it.")
		Global.hud.say("Are you going to explore it?")
		buttons.push_back(Button_Config.new("Yes","",parent_scene._start_run.bind("nav_dungeon_1")))
	if(menuid=="upgrades"):
		Tutorials.show("basic_skillpoints")
		Global.hud.clearOutput()
		Global.hud.say("You have "+str(GR.getModuleFlag("Default","SP_Unspent",0))+" skill-points.")
		Global.hud.say("")
		Global.hud.say("Upgrading your Stats give you better chances at rolls.")
	return(buttons)

func _take_fruit():
	var _item=GR.createItem("banana")
	Global.hud.say("You pickup the [b]banana[/b].")
	Global.hud.show_picture_center(load(_item.getInventoryImage()))
	Global.pc.inventory.addItem(_item)
	Global.main.getCurrentScene().continueScene()
