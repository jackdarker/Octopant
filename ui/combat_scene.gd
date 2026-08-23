class_name CombatScene extends DefaultScene

# this scene implements some turnbased combat logic
# - call setup to define combatants and arena settings
#   also define what happens afterward ("on...()" 
# - runScene
# - wait for the finished signal
# - depending on the outcome switch scene

#TODO load/save

signal fight_next

var scene_charWidget = preload("res://ui/fragments/character_hud.tscn")
var scene_hudCombat = preload("res://ui/fragments/hud_center_combat.tscn")

var combatSetup:CombatSetup

var playerParty:Array[Character]=[]
var enemyParty:Array[Character]=[]
var turnStack:Array=[]
var turnCount:int=0
var playerFleeing:bool
var playerSubmitting:bool
var actor:Character
var target:Array	# ...of Character
var skill:Skill

enum STATE {undef,battleInit,checkDefeat,preTurn,selectActor,selectSkill,selectItem,selectTarget,execSkill,battleEnd,postBattle}
var next_state:STATE=STATE.undef:
	set(value):
		next_state=value
		fight_next.emit()

func _init():
	sceneID = "FightScene"
	self.uniqueSceneID=GR.generateUniqueID()
	next_state=STATE.undef
	fight_next.connect(next)

func enterScene():
	Global.hud.hudMode = Hud.HUDMODE.Combat
	Global.hud.configureHudCenter(scene_hudCombat.instantiate())
	Global.hud.visible=true
	if(next_state==STATE.undef): # setup new combat
		set_state.call_deferred(STATE.battleInit)
	elif(next_state==STATE.battleEnd): #returned from postBattleScene
		set_state.call_deferred(STATE.postBattle)

func canSave()->bool:
	return false	#no save in combat
	
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
	elif(next_state==STATE.postBattle):
		postBattle()
	else:
		assert(false,str(next_state))

func set_state(newstate):
	next_state=newstate

func setupScene(_combatSetup:CombatSetup):
	combatSetup=_combatSetup
	turnCount=0
	playerFleeing=false
	playerSubmitting=false
	playerParty=combatSetup.playerParty.duplicate()
	enemyParty=combatSetup.enemyParty.duplicate()
	enterScene()

func battleInit():
	_destroyEnemyWidgets()
	Global.hud.clearOutput()
	Global.hud.clearInput()
	next_state=STATE.preTurn

func battleEnd():
	var _allChars=playerParty+enemyParty
	for _char:Character in _allChars:		#trigger Effect.onFightEnd
		var _effs = _char.effects.getItems()
		for _eff in _effs:
			_eff.onFightEnd()
	Global.hud.hudMode=Hud.HUDMODE.Explore
	_destroyEnemyWidgets()
	if(playerFleeing==true): 
		combatSetup.onFlee.call(self)
	elif(playerSubmitting==true): 
		combatSetup.onSubmit.call(self)
	elif(isPartyDefeated(enemyParty)):
		for item in enemyParty:
			Global.npc_defeated.emit(item)
		combatSetup.onVictory.call(self);
	elif(isPartyDefeated(playerParty)):
		if(Global.pc.getStat(StatEnum.Lust).atUL):
			combatSetup.onSubmit.call(self)
		else:
			combatSetup.onDefeat.call(self)

func postBattle():
	Global.main.removeScene(self)

func preTurn():
	turnCount+=1
	var _allChars=playerParty+enemyParty
	#remove knockedout spawned chars
	
	for _char:Character in _allChars:		#trigger Effect.processCombatTurn
		var _effs = _char.effects.getItems()
		for _eff in _effs:
			if(turnCount==1):	# trigger Effect.onFightStart
				_eff.onFightStart()
			_eff.processCombatTurn()
			
	_calcTurnOrder()
	_createEnemyWidgets()

	next_state=STATE.checkDefeat


func checkDefeat():
	Global.hud.clearInput()
	#TODO handle player fleeing
	#is any party down?
	if(isPartyDefeated(enemyParty) || isPartyDefeated(playerParty)):
		next_state=STATE.battleEnd
	else:
		next_state=STATE.selectActor

func selectActor():
	while(turnStack.size()>0):
		actor=turnStack.pop_front()
		if actor.isKnockedOut():
			continue
		else:
			skill=null
			next_state=STATE.selectSkill
			return
	
	next_state=STATE.preTurn	#next turn after all done

func selectSkill():
	Global.hud.clearInput()
	#TODO onMoveSelect()
	if(actor.isKnockedOut()):
		next_state=STATE.selectActor	#
	
	var isplayerActor=playerParty.find(actor)>=0
	if(!actor.combatAI || combatSetup.noAI):
		Global.hud.say("select skill for "+actor.getName())
		_printSkillList()
	else:
		var _res
		if(isplayerActor):
			_res=actor.combatAI.selectCombatSkill(enemyParty,playerParty)
		else:
			_res=actor.combatAI.selectCombatSkill(playerParty,enemyParty)
		skill=_res.skill
		target=_res.targets
		next_state=STATE.execSkill

func selectTarget():
	Global.hud.clearInput()
	Global.hud.say("select target for "+skill.getName())
	Global.hud.addButton("Back","",selectSkill)
	var _targetgroups=skill.targetFilter(enemyParty,playerParty)
	if _targetgroups.size()==1:	#skip select for lone enemys
		_postTargetSelect(_targetgroups[0])
	else:
		for _targetgroup in _targetgroups:
			var _name:String=Util.join(_targetgroup.map(func(_e): return _e.getName())) 
			Global.hud.addButton(_name,"",_postTargetSelect.bind(_targetgroup))

func execSkill():
	if !skill || !target:
		Global.hud.say(actor.getName() +"doesnt know what to do.")
	else:
		Global.hud.say(actor.getName() +" is going to "+skill.getName()+" "+Util.join(target.map(func(_e): return _e.uniqueID)) )
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
	Global.hud.show_picture_right(target[0].getBustImage())
	next_state=STATE.execSkill

func _calcTurnOrder():
	turnStack=playerParty+enemyParty	#TODO order depends on ?

func _destroyEnemyWidgets():
	Util.delete_children(Global.hud.hudCenter.enemyList)

func _createEnemyWidgets():
	#this creates/removes widgets depending on the parts-lists
	var i
	var _actual=[]
	var _actualI=[]
	var _remove=[]
	
	i=0
	for _char in enemyParty:
		_actual.push_back(_char.getName())
		_actualI.push_back(i)
		i+=1
	
	for _widget in Global.hud.hudCenter.enemyList.get_children():
		i=_actual.find(_widget.characterName)
		if(i<0):
			_remove.push_back(_widget)
		else:
			_actual.remove_at(i)
			_actualI.remove_at(i)
	
	for _char in _remove:
		Global.hud.hudCenter.enemyList.remove_child(_char)
		
	for _index in _actualI:
		var _char=enemyParty[_index]
		var widget:CharacterHud =scene_charWidget.instantiate()
		_char.status.registerSignalItemChanged(widget.on_stat_update.bind(_char).unbind(2),"pain")		
		_char.status.registerSignalItemChanged(widget.on_stat_update.bind(_char).unbind(2),"fatigue")
		_char.status.registerSignalItemChanged(widget.on_stat_update.bind(_char).unbind(2),StatEnum.Lust)
		_char.effects.registerSignalItemsChanged(func(ID):widget.on_effect_update(_char,ID))
		widget.on_stat_update.call_deferred(_char)
		Global.hud.hudCenter.enemyList.add_child(widget)
		widget.on_stat_update.call_deferred(_char)

func isPartyDefeated(party:Array[Character]):
	for _char:Character in party:
		if(!_char.isKnockedOut()):
			return(false)
	return(true)

## call this onVictory to grab loot & XP from Mobs
func fetchLoot()->String: # if you are victorious: grant XP & transfer Loot to player 
	var msg=''
	var XP=0
	var maxLevel = 0
	var _rnd=randf()*100
	for n in self.playerParty:
		maxLevel = max(maxLevel,n.level);
	#let _x = window.gm.player.Stats.get('luck').value;
	#_rnd = _rnd-max(-25,min(25,_x)) # player luck capped
	for n in self.enemyParty:
		for i in range(n.loot.size()):
			var _item=Util.pickRandomFromArray(n.loot,n.loot.map(func(x):return(x.chance)))
			if(_item && _item.ID):
				var _item2=GR.createItem(_item.ID)
				_item2.amount=_item.amount
				msg+= str(_item.amount)+'x '+ _item2.getName()+' '
				Global.pc.inventory.addItem(_item2)

		# XP reduced/increased if your level is bigger/smaller then foes by 25% per level
		#XP+=Math.floor(n.baseXPReward* Math.min(3,Math.max(0,1+(n.level-maxLevel)*0.25)));

	msg = 'You got some loot: '+str(XP) +'XP '+msg+'[br]'
	for n in self.playerParty:
		n.XP+=XP  #todo all get the same?
	return(msg)
