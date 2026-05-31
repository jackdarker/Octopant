class_name CombatSkill extends Skill

# a skill that is used to deal damage in combat
# Note: None-Attack skills might derive from Skill with canBeUsedInCombat=true

func canUseInCombat()->bool:
	return true

func doAction(_action:String,_targets):
	getCost().pay(user)
	for _target in _targets:
		if(checkDogded(_target).OK):
			Global.hud.say(_target.getName()+" avoided "+user.getName()+" attack.")
		else:
			applyAction(_action,_target)
	coolDown=defCoolDown

## rolls if the receiver dodged the attack
func checkDogded(_target:Character)->Result:
	var _res=Result.create(true,"")
	#self.user
	# success depends on: receiver-dodgerating, attack-hitchance, 
	# receiver stunned, blinded,
	if(randf()<0.9):
		_res.OK=false
	return _res

#TODO checkParry   checkBlock

#TODO func getAnticipationText(_attacker, _receiver):
