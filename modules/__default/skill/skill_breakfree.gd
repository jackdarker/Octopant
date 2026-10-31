extends CombatSkill

var _damage:float=10

func _init():
	super()
	ID="Skill_Breakfree"
	tags.push_back(SkillTagEnum.ModeGrapple)


func getName()->String:
	return "Break free"

func getDescription()->String:
	return "Use poise to break the grapple"

func getAttackForTarget(target:Character)->AttackData:
	var attack:=AttackData.create()
	attack.hitChance=0.80
	#attack.onHit=[{"target":target,"eff":[effDamage.create(_damage)]}]
	#attack.onHitMsg=func():return(target.getName()+" received a punch")
	return attack
