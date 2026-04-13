extends SceneExtension

const sceneID="nav_cliff"
const max_h:=30.0
func on_setupScene():
	GR.setModuleFlag("Default","Cliff_Height",0)	#reset on arrival

func on_enterScene():
	parent_scene.set_bg(load("res://assets/images/bg/nav_cliff_sun.png"))
	if (GR.getModuleFlag("Default","Found_Cliff",0)<=0):
		Global.hud.say("Your walk at the beach finally brings you to a high cliff.")
		GR.setModuleFlag("Default","Found_Cliff",1)
	Global.hud.say("The cliff looks climbable even for your poor abilitys.")
	Global.hud.say("As long as you have some rope with you it should be safe enough.")
	var _r=GR.getModuleFlag("Default","Cliff_Ropes",0)
	if(_r>0):
		Global.hud.say(str(_r)+" ropes are installed by you. They should make it easier to climb.")
	
	var _h=GR.getModuleFlag("Default","Cliff_Height",0)
	if(_h>0):
		Global.hud.say("You have climbed "+str(_h)+"m.")
	
	
func get_buttons(menuid:String,buttons:Array):
	var _h=GR.getModuleFlag("Default","Cliff_Height",0)
	var _r=GR.getModuleFlag("Default","Cliff_Ropes",0)
	if(menuid==""):
		if(_h>=max_h):
			Global.hud.clearOutput()
			Global.hud.say("You made it to the top of the cliff.")
			buttons.push_back(Button_Config.new("Look around","",parent_scene.menu.bind("lookout")))
		else:
			buttons.push_back(Button_Config.new("go somewhere else...","",parent_scene.menu.bind("walk")))
			buttons.push_back(Button_Config.new("explore","",parent_scene._on_bt_explore_pressed,parent_scene._requiresFatigue))
			buttons.push_back(Button_Config.new("climb up","",_on_climb,_can_climb))
	if(menuid=="walk"):
		Global.hud.say("Where would you like to go?")
		buttons.push_back(Button_Config.new("Beach","",Global.main.runScene.bind("nav_beach")))
	if(menuid=="climb"):
		Global.hud.say("You have climbed "+str(_h)+"m.")
		buttons.push_back(Button_Config.new("Return to ground","",_on_climb_down))
		buttons.push_back(Button_Config.new("Climb further up","",_on_climb,_can_climb))
		if((_h>=10 && _r<=0)||(_h>=20 && _r<=1)||(_h>=30 && _r<=2) ):
			buttons.push_back(Button_Config.new("Install a rope","makes it easier to climb up next time",_on_rope,_can_rope))
	if(menuid=="lookout"):
		Global.hud.say("You get a good overview of the already familiar beach. A vast forest stretches further inside of the landmass.")
		Global.hud.say("Behind the forest a chain of hills and mountains block the view.")
		Global.hud.say("Still, its impossible to tell if this is an island or just the tip of a bigger landmass.")
		buttons.push_back(Button_Config.new("Return to ground","",parent_scene.menu.bind("")))
	return(buttons)

func _on_climb_down():
	GR.setModuleFlag("Default","Cliff_Height",0)
	Global.hud.clearInput()
	Global.hud.clearOutput()
	Global.hud.say("Gladly you made it back to the ground without much hassle.")
	parent_scene.menu("")

func _on_climb():
	_can_climb(true)
	var i=randi_range(0, 100)
	GR.increaseModuleFlag("Default","Cliff_Height",10)
	Global.hud.clearInput()
	Global.hud.clearOutput()
	var _h=GR.getModuleFlag("Default","Cliff_Height",0)
	if _h>=max_h:
		parent_scene.menu("")
	else:
		parent_scene.menu("climb",true)
	
func _can_climb(apply:bool=false):
	var _h=GR.getModuleFlag("Default","Cliff_Height",0)
	var _r=GR.getModuleFlag("Default","Cliff_Ropes",0)
	if (_r >=(floor(_h/10.0)-1) ):
		return CondCheck.create([CondCheck.Cond_StatChange.create(StatEnum.Fatigue,20)]).check(Global.pc,apply)
	return CondCheck.create([CondCheck.Cond_StatChange.create(StatEnum.Fatigue,40)]).check(Global.pc,apply)

func _on_rope():
	_can_rope(true)
	GR.increaseModuleFlag("Default","Cliff_Ropes",1)
	Global.hud.say("Tying a rope to a root of a tree that has sprouted from a fracture between the rocks.")
	parent_scene.menu("climb")
	
func _can_rope(apply:bool=false):
	return CondCheck.create([CondCheck.Cond_Resource.create("rope_liane",1)]).check(Global.pc,apply)
