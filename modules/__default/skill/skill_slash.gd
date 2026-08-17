extends CombatSkill

func _init():
	super()
	ID="Skill_Slash"
	tags.push_back(SkillTagEnum.Attack)

func getName()->String:
	return "Slash"

func getDescription()->String:
	return "Cut them with your weapon."

func getAttackForTarget(target:Character)->AttackData:
	var attack:=AttackData.create()
	attack.onHit=[{"target":target,"eff":[GR.createEffect("eff_damage"),GR.createEffect("eff_bleed")]}]
	attack.onHitMsg=func():return(target.getName()+" got hit and bleeds.")
	return attack
