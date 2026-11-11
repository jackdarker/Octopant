extends CombatSkill

var _damage:float=10

func _init():
	super()
	ID="Skill_Special"
	tags.push_back(SkillTagEnum.ModeCombat)
	tags.push_back(SkillTagEnum.Special)


func getName()->String:
	return "Special"

func getDescription()->String:
	return ""
