extends Skill

func _init():
	super()
	ID="Skill_Heal"
	tags.push_back(SkillTagEnum.Heal)
	defCoolDown=4

func canUseInCombat()->bool:
	return true

func getName()->String:
	return "Heal self"

func getDescription()->String:
	return "Patch yourself up."

func applyAction(_action:String,_target:Character):
	var _res=Result.create(true,"")
	var _stat=_target.getStat(StatEnum.Pain)
	_stat.modify(_stat.ul*-0.5)
	_res.Msg=user.getName() +" heals " + (_target.getName() if user!=_target else "")
	Global.hud.say(_res.Msg)

func targetFilter(enemys:Array[Character],_own:Array[Character]):
	var _targets:Array=[];
	var own=Skill.targetFilterAlive(_own)
	for _t in own:
		_targets.push_back([_t])
	return _targets
