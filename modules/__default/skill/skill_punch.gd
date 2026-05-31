extends CombatSkill

func _init():
	super()
	ID="Skill_Punch"
	tags.push_back(SkillTagEnum.Attack)

func getName()->String:
	return "Punch"

func getDescription()->String:
	return "Hit them with your fist."

func applyAction(_action:String,_target:Character):
	var _res=Result.create(true,"")
	_target.getStat(StatEnum.Pain).modify(15)
	_res.Msg=user.getName() +" punches " + _target.getName()
	Global.hud.say(_res.Msg)
