class_name CombatAIBase extends Node

class CombatSkillResult extends Result:
	var skill:Skill
	var target:Character
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
		return(wrefCharacter.get_ref())

## override this; default will just choose a random target and try to find a random Attack-Skill to use
func selectCombatSkill(enemyParty:Array[Character],ownParty:Array[Character])->CombatSkillResult:
	var _res:CombatSkillResult=CombatSkillResult.create(true,"")
	var skills=Inventory.filter_by_tag(char.skills.getItems(),[SkillTagEnum.Attack])
	skills.shuffle()
	_res.target=enemyParty[randf_range(0,enemyParty.size())]
	for skill:Skill in skills:
		if skill.canDo("",_res.target).OK:
			_res.skill=skill
			break
	return _res
