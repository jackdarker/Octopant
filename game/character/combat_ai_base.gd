class_name CombatAIBase extends Node

## support class
class CombatSkillResult extends Result:
	var skill:Skill
	var targets:Array[Character]
	static func create(ok,msg)->CombatSkillResult:
		var _n=CombatSkillResult.new()
		_n.OK=ok
		_n.Msg=msg
		return _n

var wrefCharacter:WeakRef=null
var char:Character:
	set(value):
		wrefCharacter=weakref(value)
	get:
		return(wrefCharacter.get_ref() if wrefCharacter else null)

var wrefScene:WeakRef=null
var scene:CombatScene:
	set(value):
		wrefScene=weakref(value)
	get:
		return(wrefScene.get_ref() if wrefScene else null)

var combat_beh:=["Skill_Attack","Skill_Attack","Skill_Trip"]
var grapple_beh:=["Skill_Grope","Skill_Grope"]
var moves=combat_beh.duplicate()

## override this; default will just choose a random target and try to find a random Attack-Skill to use
func selectCombatSkill(enemyParty:Array[Character],_ownParty:Array[Character])->CombatSkillResult:
	var _res:CombatSkillResult=CombatSkillResult.create(true,"")
	# choose random from moveset; if all moves done use special; after special restart moveset
	var skillid:String=moves.pop_at(randi_range(0,moves.size()-1))
	if(scene.mode==scene.MODE.grapple):
		if(skillid=="Skill_SpecialGrab"):
			moves=grapple_beh.duplicate()
			Inventory.filter_by_tag(char.skills.getItems(),[SkillTagEnum.Special])
		elif(moves.size()==0):
			moves=["Skill_SpecialGrab"]
	else:
		if(skillid=="Skill_Special"):
			moves=combat_beh.duplicate()
		elif(moves.size()==0):
			moves=["Skill_Special"]

	_res.skill=char.skills.getItemByID(skillid)
	return _res


func selectCombatSkill_old(enemyParty:Array[Character],_ownParty:Array[Character])->CombatSkillResult:
	var _res:CombatSkillResult=CombatSkillResult.create(true,"")
	var skillsT=Inventory.filter_by_tag(char.skills.getItems(),[SkillTagEnum.Tease])
	skillsT.shuffle()
	var skillsA=Inventory.filter_by_tag(char.skills.getItems(),[SkillTagEnum.Attack])
	skillsA.shuffle()
	var skillsH=Inventory.filter_by_tag(char.skills.getItems(),[SkillTagEnum.Heal])
	skillsH.shuffle()
	# heal if damaged
	if(char.getStat(StatEnum.Pain).value_percent>50):
		_res.targets=[char]
		for skill:Skill in skillsH:
			if skill.canDo("",_res.targets).OK:
				_res.skill=skill
				return _res
	
	# chance to tease if horny
	_res.targets=[enemyParty[randf_range(0,enemyParty.size())]]
	if(randf()>0.3 && char.getStat(StatEnum.Lust).value_percent>20):
		for skill:Skill in skillsT:
			if skill.canDo("",_res.targets).OK:
				_res.skill=skill
				return _res
	
	# damage
	_res.targets=[enemyParty[randf_range(0,enemyParty.size())]]
	for skill:Skill in skillsA:
		if skill.canDo("",_res.targets).OK:
			_res.skill=skill
			return _res
	return _res
