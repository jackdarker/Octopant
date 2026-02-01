class_name CombatScene extends DefaultScene

# this scene implements some turnbased combat logic
# - call setup to define combatants and arena settings
# - runScene
# - wait for the finished signal
# - depending on the outcome switch scene

signal fight_ended(outcome)
signal fight_next

var scene_charWidget = preload("res://ui/character_hud.tscn")

var combatSetup:CombatSetup

var playerParty:Array[Character]=[]
var enemyParty:Array[Character]=[]
var turnStack:Array=[]
var turnCount:int=0
var actor:Character
var target:Character
var skill:Skill

enum STATE {undef,battleInit,checkDefeat,preTurn,selectActor,selectSkill,selectItem,selectTarget,execSkill,battleEnd}
var next_state:STATE=STATE.undef:
	set(value):
		next_state=value
		fight_next.emit()

func _init():
	sceneID = "FightScene"
	fight_next.connect(next)

func next():
	if(next_state==STATE.battleInit):
		battleInit()
	elif(next_state==STATE.preTurn):
		preTurn()
	elif (next_state==STATE.checkDefeat):
		checkDefeat()
	elif(next_state==STATE.selectActor):
		selectActor()
	elif(next_state==STATE.selectSkill):
		selectSkill()
	elif(next_state==STATE.selectTarget):
		selectTarget()
	elif(next_state==STATE.execSkill):
		execSkill()
	elif(next_state==STATE.battleEnd):
		battleEnd()
	
func setupScene(_combatSetup:CombatSetup):
	combatSetup=_combatSetup
	turnCount=0
	playerParty=combatSetup.playerParty.duplicate()
	enemyParty=combatSetup.enemyParty.duplicate()
	Global.hud.hudMode = Hud.HUDMODE.Combat
	next_state=STATE.battleInit

func battleInit():
	var _allChars=playerParty+enemyParty
	#trigger Effect.onFightStart
	for _char:Character in _allChars:
		var _effs = _char.effects.getItems()
		for _eff in _effs:
			_eff.onFightStart()
	next_state=STATE.preTurn

func battleEnd():
	var _allChars=playerParty+enemyParty
	#trigger Effect.onFightEnd
	for _char:Character in _allChars:
		var _effs = _char.effects.getItems()
		for _eff in _effs:
			_eff.onFightEnd()
	Global.main.removeScene(self)	#TODO


func preTurn():
	turnCount+=1
	#remove knockedout spawned chars
	
	#trigger Effect.processCombatTurn
	
	_calcTurnOrder()
	_createEnemyWidgets()
	next_state=STATE.checkDefeat


func checkDefeat():
	#handle player fleeing
	#is any party down?
	if(isPartyDefeated(enemyParty)):
		next_state=STATE.battleEnd
	elif(isPartyDefeated(playerParty)):
		next_state=STATE.battleEnd
	else:
		next_state=STATE.selectActor

func selectActor():
	if(turnStack.size()>0):
		actor=turnStack.pop_front()
		skill=null
		next_state=STATE.selectSkill
	else:
		next_state=STATE.preTurn	#next turn after all done

func selectSkill():
	Global.hud.clearInput()
	Global.hud.say("select skill for "+actor.getName())
	#TODO onMoveSelect()
	if(actor.isKnockedOut()):
		next_state=STATE.selectActor	#
	
	var isplayerActor=playerParty.find(actor)>=0
	if(!actor.combatAI):
		_printSkillList()
	else:
		var _res
		if(isplayerActor):
			_res=actor.combatAI.selectCombatSkill(enemyParty,playerParty)
		else:
			_res=actor.combatAI.selectCombatSkill(playerParty,enemyParty)
		skill=_res.skill
		target=_res.target
		next_state=STATE.execSkill

func selectTarget():
	Global.hud.clearInput()
	Global.hud.say("select target for "+skill.getName())
	Global.hud.addButton("Back","",selectSkill)
	var _allChars=playerParty+enemyParty
	var _targets=skill.targetFilter(_allChars)
	for _target in _targets:
		Global.hud.addButton(_target.getName(),"",_postTargetSelect.bind(_target))

func execSkill():
	skill.doAction("",target)
	_postExecute()
	
func _printSkillList():
	Global.hud.clearInput()
	Global.hud.addButton("Skip","",_postExecute)

	for _skill in actor.skills.getItems():
		if _skill.canUseInCombat():
			Global.hud.addButton(_skill.getName(),_skill.getDescription(),_postSkillSelect.bind(_skill))


func _postExecute():
	next_state=STATE.checkDefeat

func _postSkillSelect(_skill):
	skill=_skill
	next_state=STATE.selectTarget

func _postTargetSelect(_target):
	target=_target
	next_state=STATE.execSkill

func _calcTurnOrder():
	turnStack=playerParty+enemyParty

func _createEnemyWidgets():
	var widget =scene_charWidget.instantiate()
	#this creates/removes widgets depending on the parts-lists
	Global.hud.enemyList.add_child()
	pass

func isPartyDefeated(party:Array[Character]):
	for _char:Character in party:
		if(!_char.isKnockedOut()):
			return(false)
	return(true)

func targetFilerAlive(party):
	var _targets=[]
	for _char:Character in party:
		if(!_char.isKnockedOut()):
			_targets.push_back(_char)
	return _targets
