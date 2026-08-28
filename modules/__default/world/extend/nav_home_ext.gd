extends SceneExtension

const sceneID="nav_home"

func on_enterScene():
	parent_scene.set_bg(load("res://assets/images/bg/nav_home_sun.png"))
	if(GR.getModuleFlag("Default","Beach_Shack",0)==0):
		GR.setModuleFlag("Default","Beach_Shack",1)
		Global.hud.say("There's an old shack there, made of twigs and palm fronds. It looks like it's been abandoned for quite some time. If you have to, you could spend the night here.")
	else:
		Global.hud.say("The cabin at the beach.")

func get_buttons(menuid:String,buttons:Array):
	if(menuid==""):
		buttons.push_back(Button_Config.new("go somewhere else...","",parent_scene.menu.bind("walk")))
		buttons.push_back(Button_Config.new("craft...","",parent_scene._on_bt_craft_pressed))
		buttons.push_back(Button_Config.new("grab some berries","",_take_fruit))
		buttons.push_back(Button_Config.new("sleep until morning","",parent_scene._on_bt_sleep_pressed))
	if(menuid=="walk"):
		Global.hud.say("Where would you like to go?")
		#if(GR.getModuleFlag("Default","Found_Beach",0)>0):
		buttons.push_back(Button_Config.new("Beach","",Global.main.runScene.bind("nav_beach")))
		buttons.push_back(Button_Config.new("debug","",Global.main.runScene.bind("nav_debug")))
			
	return(buttons)

func _take_fruit():
	var _item=GR.createItem("banana")
	Global.hud.say("You pickup the [b]banana[/b].")
	Global.hud.show_picture_center(load(_item.getInventoryImage()))
	Global.pc.inventory.addItem(_item)
	Global.main.getCurrentScene().continueScene()
