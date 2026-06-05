extends CombatSkill

func _init():
	super()
	ID="Skill_Blind"
	tags.push_back(SkillTagEnum.Attack)
	defCoolDown=4

func getName()->String:
	return "Blind"

func getDescription()->String:
	return "Blind them."

func applyAction(_action:String,_target:Character):
	var _res=Result.create(true,"")
	GR.createEffect("eff_blind").applyTo(_target)
	_res.Msg=user.getName() +" blinds " + _target.getName()
	Global.hud.say(_res.Msg)
