extends CombatFlavour

func hitByEnemy(skill_Player:Skill,skill_Enemy:Skill)->int:
	if(skill_Enemy.ID==CombatAIBase.SKILL_ATTACK):
		Global.hud.say("The lizardman slashs at you with its claws.")
		return 1
	if(skill_Enemy.ID==CombatAIBase.SKILL_TRIP):
		Global.hud.say("The lizardman trips you with its tail.")
		return 1
	if(skill_Enemy.ID==CombatAIBase.SKILL_TEASE):
		Global.hud.say("The lizardman shows off by flexing his muscles.")
		return 1
	if(skill_Enemy.ID==CombatAIBase.SKILL_GROPE):
		Global.hud.say("The lizardman lets grabs at ypur body with its clawed hands.")
		return 1
	if(skill_Enemy.ID==CombatAIBase.SKILL_SPECIAL):
		Global.hud.say("The lizardman makes a combo with his clawed hands.")
		player.getStat(StatEnum.Poise).modify(-1*15)
		player.getStat(StatEnum.Pain).modify(15)
		return 1	
	if(skill_Enemy.ID==CombatAIBase.SKILL_SPECIALGRAB):
		Global.hud.say("Aditionally to his hands groping your flesh, he also uses his flexible tail.")
		player.getStat(StatEnum.Poise).modify(-1*15)
		player.getStat(StatEnum.Lust).modify(15)
		return 1
	return 0

func intoGrapple()->int:
	Global.hud.say("As you stumble to ground, the enemy is quickly all over you grab you with his scaled hands.")
	Global.hud.say("His tapered dick is already poking out of its slit.")
	Global.hud.show_picture_right(load("res://assets/images/chars/Crab.png"))
	return 1

func lustTrigger()->int:
	Global.hud.say("He rails you with his reptile cock until your orgasm triggers.")
	return 1
