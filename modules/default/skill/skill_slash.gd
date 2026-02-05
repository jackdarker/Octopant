extends Skill

func _init():
	super()
	ID="Skill_Slash"

func getName()->String:
	return "Slash"

func getDescription()->String:
	return "Cut them with your weapon."

func canUseInCombat()->bool:
	return true

func applyAction(_action:String,_target:Character):
	var _res=Result.create(true,"")
	_target.getStat(StatEnum.Pain).modify(15)
	GlobalRegistry.createEffect("eff_bleed").applyTo(_target)
	_res.Msg=user.getName() +" hits " + _target.getName()
	Global.hud.say(_res.Msg)
