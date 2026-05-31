extends CombatSkill

func _init():
	super()
	ID="Skill_Cleave"
	tags.push_back(SkillTagEnum.Attack)

func getName()->String:
	return "Cleave"

func getDescription()->String:
	return "Hit multiple targets with melee."

func applyAction(_action:String,_target:Character):
	var _res=Result.create(true,"")
	_target.getStat(StatEnum.Pain).modify(15)
	GR.createEffect("eff_bleed").applyTo(_target)
	_res.Msg=user.getName() +" hits " + _target.getName()
	Global.hud.say(_res.Msg)

func targetFilter(enemys:Array[Character],_own:Array[Character]):
	var _targets:Array=super.targetFilter(enemys,_own)
	if _targets.size()>1:
		_targets.push_front(enemys)
	return _targets
