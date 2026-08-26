extends CombatSkill


func _init():
	super()
	ID="Skill_Punch"
	tags.push_back(SkillTagEnum.Attack)


func getName()->String:
	return "Punch"

func getDescription()->String:
	return "Hit them with your fist."

func getAttackForTarget(target:Character)->AttackData:
	var attack:=AttackData.create()
	attack.onHit=[{"target":target,"eff":[effDamage.create(10)]}]
	attack.onHitMsg=func():return(target.getName()+" received a punch")
	return attack
