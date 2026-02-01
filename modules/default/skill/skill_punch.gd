extends Skill

func _init():
	super()
	ID="Skill_Punch"
	#TODO tags.push_back(ItemTagEnum.Ingredient)

func getName()->String:
	return "Punch"

func getDescription()->String:
	return "Hit them with your fist."

func canUseInCombat()->bool:
	return true

func applyAction(_action:String,_target:Character):
	var _res=Result.create(true,"")
	_target.getStat(StatEnum.Pain).modify(15)
	_res.Msg=user.getName() +" hits " + _target.getName()
	Global.hud.say(_res.Msg)
