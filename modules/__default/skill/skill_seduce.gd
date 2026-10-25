extends CombatSkill

var _damage:float=10

func _init():
	super()
	ID="Skill_Seduce"
	tags.push_back(SkillTagEnum.Attack)


func getName()->String:
	return "Seduce"

func getDescription()->String:
	return "Use your cunning and body to impress them."

func getAttackForTarget(target:Character)->AttackData:
	var attack:=AttackData.create()
	attack.hitChance=0.80
	attack.onHit=[{"target":target,"eff":[effDamage.create(_damage)]}]
	attack.onHitMsg=func():return(target.getName()+" received a punch")
	return attack
