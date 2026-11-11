extends EventBase

# an event that triggers combat

var style:int=0

func _init():
	if(ID=="" || ID=="unknown"):
		ID="EventFindTrouble"
	super()

func getName()->String:
	match style:
		1: return("go left")
		2: return("go right")
		_: return("go right")

func react(_triggerID,_location,_args)->bool:
	Global.hud.clearInput()
	var _rnd=randi()%100
	if(_rnd<=50):
		style=1
		Global.hud.say("Some JellyFish suddenly appears.")
	else:
		style=2
		Global.hud.say("Some antropomorphic otter splashs from the waves")
	Global.hud.addButton("Engage","",_engage,null)
	#Global.hud.addButton("Run away","",_ignore,null)
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
	var _mob
	_setup.playerParty.push_back(Global.pc)
	_setup.adv_start=50
	if(style==1):
		_mob=GR.createCharacter("JellyFish")
	elif(style==2):
		_mob=GR.createCharacter("Lizardman")
	else:
		_mob=GR.createCharacter("Otter")
		_mob.getStat(StatEnum.Lust).modify(20)
		_setup.onSubmit= func(scene:CombatScene):
			Global.main.runScene("interaction_scene",
				["dlg_sbm_otter",	null],
				Global.main.getCurrentScene().uniqueSceneID)
	_setup.enemyParty.push_back(_mob)
	Global.main.runScene("combat_scene",[_setup],Global.main.currentSceneUID)
