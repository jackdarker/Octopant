extends EventBase

# an event that triggers combat

func _init():
	ID="EventFindTroubleBeach"
	super()
	

func react(_triggerID,_location,_args)->bool:
	Global.hud.clearInput()
	Global.hud.say("Some crab suddenly appears from the sand and claps with his claws.")
	Global.hud.addButton("Engage","",_engage,null)
	Global.hud.addButton("Run away","",_ignore,null)
	return true
	
func canRun(_trigger,_location,_args)->bool:
	return true

func getWeight()->float:
	return 0.5

func _ignore():
	Global.hud.say("You got away")
	Global.main.getCurrentScene().continueScene()

func _engage():
	var _setup=CombatSetup.new()
	_setup.playerParty.push_back(Global.pc)
	_setup.enemyParty.push_back(GR.createCharacter("Crab"))
	Global.main.runScene("combat_scene",[_setup],Global.main.currentSceneUID)
