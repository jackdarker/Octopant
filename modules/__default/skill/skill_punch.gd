extends CombatSkill

var _damage:float=10

func _init():
	super()
	ID="Skill_Punch"
	tags.push_back(SkillTagEnum.Attack)


func getName()->String:
	return "Punch"

func getDescription()->String:
	return "Hit them with your fist. \nDMG: "+str(_damage)

func getAttackForTarget(target:Character)->AttackData:
	var attack:=AttackData.create()
	attack.hitChance=80.0
	attack.onHit=[{"target":target,"eff":[effDamage.create(_damage)]}]
	attack.onHitMsg=func():return(target.getName()+" received a punch")
	return attack
