extends CombatSkill

var _damage:float=10

func _init():
	super()
	ID="Skill_Struggle"
	tags.push_back(SkillTagEnum.ModeGrapple)


func getName()->String:
	return "Struggle"

func getDescription()->String:
	return "Struggle to increase poise"

func getAttackForTarget(target:Character)->AttackData:
	var attack:=AttackData.create()
	attack.hitChance=0.80
	#attack.onHit=[{"target":target,"eff":[effDamage.create(_damage)]}]
	#attack.onHitMsg=func():return(target.getName()+" received a punch")
	return attack
