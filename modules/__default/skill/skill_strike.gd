extends CombatSkill

func _init():
	if(ID=="" || ID=="unknown"):
		ID="Skill_Strike"
	super()
	tags.push_back(SkillTagEnum.Attack)

func getName()->String:
	return "Strike"

func getDescription()->String:
	return "Hit them with your weapon."

func getAttackForTarget(target:Character)->AttackData:
	var attack:=AttackData.create()
	attack.hitChance=0.80
	var rHand=self.user.outfit.getItemForSlot(BodySlotEnum.RHand)
	if(rHand && rHand.has_method("attackMod")):
		attack=rHand.attackMod(target)
		attack.onHitMsg=func():return(target.getName()+" got hit with "+rHand.getName()+".")
	return attack
