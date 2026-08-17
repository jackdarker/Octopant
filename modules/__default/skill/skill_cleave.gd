extends CombatSkill

func _init():
	super()
	ID="Skill_Cleave"
	tags.push_back(SkillTagEnum.Attack)
	defCoolDown=4

func getName()->String:
	return "Cleave"

func getDescription()->String:
	return "Hit multiple targets with melee."


func getAttackForTarget(target:Character)->AttackData:
	var attack:=AttackData.create()
	attack.onHit=[{"target":target,"eff":[GR.createEffect("eff_damage"),GR.createEffect("eff_bleed")]}]
	attack.onHitMsg=func():return(target.getName()+" got hit and bleeds.")
	return attack

func targetFilter(enemys:Array[Character],_own:Array[Character]):
	var _targets:Array=super.targetFilter(enemys,_own)
	if _targets.size()>1:
		_targets.push_front(enemys)
	return _targets
