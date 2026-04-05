extends "res://modules/__default/world/nav_beach.gd"

# the player has to pass multiple tests before he gets a prize
# this is triggered by event_delve_beach


func _init() -> void:
	sceneID="dng_beach"

func enterScene():
	Global.pc.location=self.sceneID
	#scene_ext=GR.getSceneExtensions(self.sceneID,self)
	Global.hud.visible=true
	Global.hud.clearOutput()
	Global.hud.clearInput()
	#for ext in scene_ext:
	#	if ext.has_method("on_enterScene"):			#TODO use extension?
	#		ext.on_enterScene()
	#menu("")
	set_bg(load("res://assets/images/bg/nav_beach_sun.png"))
	var room=GR.getModuleFlag("Squishl","Delve_State",0)
	if (room<=1):
		Global.hud.say("You walk into the water. There is something around your feet...")
		Global.hud.addButton("Next","",_on_bt_fight_pressed)
	else :
		GR.increaseModuleFlag("Squishl","Daily_Treasure",1)
		Global.hud.say("Finally you get to your prize-")
		Global.hud.addButton("Next","",_on_prize_claim)

func _on_bt_fight_pressed():
	var _setup=CombatSetup.new()
	var _x=Global.pc.effects.getItems()
	_setup.onVictory= _postVictory
	_setup.playerParty.push_back(Global.pc)
	_setup.enemyParty.push_back(GR.createCharacter("Crab"))
	Global.main.runScene("combat_scene",
		[_setup],self.uniqueSceneID)

func _postVictory(combatScene):
	GR.increaseModuleFlag("Squishl","Delve_State",1)
	Global.hud.say("You have won this fight")	#todo fetchloot
	Global.hud.addButton("Next","",func():Global.main.removeScene(combatScene))

func _on_prize_claim():	
	Global.main.removeScene(self)
