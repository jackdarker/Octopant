extends CombatSkill

var _damage:float=10

func _init():
	super()
	ID="Skill_SpecialGrab"
	tags.push_back(SkillTagEnum.ModeGrapple)
	tags.push_back(SkillTagEnum.Special)


func getName()->String:
	return "Special"

func getDescription()->String:
	return ""
