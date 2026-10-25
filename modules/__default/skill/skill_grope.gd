extends CombatSkill

var _damage:float=10

func _init():
	super()
	ID="Skill_Grope"
	tags.push_back(SkillTagEnum.ModeGrapple)


func getName()->String:
	return "Grope"

func getDescription()->String:
	return ""

func getAttackForTarget(target:Character)->AttackData:
	var attack:=AttackData.create()
	attack.hitChance=0.80
	#attack.onHit=[{"target":target,"eff":[effDamage.create(_damage)]}]
	#attack.onHitMsg=func():return(target.getName()+" received a punch")
	return attack
