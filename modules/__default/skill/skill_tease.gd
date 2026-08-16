extends CombatSkill

func _init():
	super()
	ID="Skill_Tease"
	tags.push_back(SkillTagEnum.Tease)

func getName()->String:
	return "Tease"

func getDescription()->String:
	return "Make a suggestive move."

func applyAction(_action:String,_target:Character):
	var _res=Result.create(true,"")
	_target.getStat(StatEnum.Lust).modify(15)
	_res.Msg=user.getName() +" teases " + _target.getName()	#TODO improve desc
	Global.hud.say(_res.Msg)
