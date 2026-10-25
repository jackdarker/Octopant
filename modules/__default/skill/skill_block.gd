extends CombatSkill

var _damage:float=10

func _init():
	super()
	ID="Skill_Block"
	tags.push_back(SkillTagEnum.ModeCombat)


func getName()->String:
	return "Block"

func getDescription()->String:
	return "Avoid damage"

func getAttackForTarget(target:Character)->AttackData:
	var attack:=AttackData.create()
	attack.hitChance=0.80
	#attack.onHit=[{"target":target,"eff":[effDamage.create(_damage)]}]
	#attack.onHitMsg=func():return(target.getName()+" received a punch")
	return attack
