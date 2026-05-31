extends CombatSkill

func _init():
	super()
	ID="Skill_Paralyse"
	tags.push_back(SkillTagEnum.Attack)
	defCoolDown=4

func getName()->String:
	return "Paralyse"

func getDescription()->String:
	return "Paralyse them with poison."

func applyAction(_action:String,_target:Character):
	var _res=Result.create(true,"")
	_target.getStat(StatEnum.Pain).modify(10)
	GR.createEffect("eff_paralyse").applyTo(_target)
	_res.Msg=user.getName() +" hits " + _target.getName()
	Global.hud.say(_res.Msg)
