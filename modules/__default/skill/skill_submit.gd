extends Skill

## player can give up to fight. Outcome has to be done in submitscene
## player only!

func _init():
	super()
	ID="Skill_Submit"
	defCoolDown=3

func canUseInCombat()->bool:
	return true

func getName()->String:
	return "Submit"

func getDescription()->String:
	return "Offer to submit at her mercy."

func applyAction(_action:String,_target:Character):
	var _res=Result.create(true,"")
	_res.Msg=user.getName() +" submits to " + _target.getName()
	Global.hud.say(_res.Msg)
