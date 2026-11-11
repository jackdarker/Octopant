extends CombatFlavour

func hitByEnemy(skill_Player:Skill,skill_Enemy:Skill)->int:
	if(skill_Enemy.ID==CombatAIBase.SKILL_ATTACK):
		Global.hud.say("The jellyfishs slaps you with its tentacles.")
		return 1
	if(skill_Enemy.ID==CombatAIBase.SKILL_TRIP):
		Global.hud.say("The jellyfishs wraps its tentacles around you.")
		return 1
	if(skill_Enemy.ID==CombatAIBase.SKILL_TEASE):
		Global.hud.say("The jellyfishs tackles you with its slippery tentacles.")
		return 1
	if(skill_Enemy.ID==CombatAIBase.SKILL_GROPE):
		Global.hud.say("The jellyfishs lets it's tentacles slide all over you.")
		return 1
	if(skill_Enemy.ID==CombatAIBase.SKILL_SPECIAL):
		Global.hud.say("The jellyfish dash's at you.")
		player.getStat(StatEnum.Poise).modify(-1*15)
		player.getStat(StatEnum.Pain).modify(15)
		return 1	
	if(skill_Enemy.ID==CombatAIBase.SKILL_SPECIALGRAB):
		Global.hud.say("The tentacles release lots of deliberating poison in your veins.")
		player.getStat(StatEnum.Poise).modify(-1*15)
		player.getStat(StatEnum.Lust).modify(15)
		return 1
	return 0

func intoGrapple()->int:
	Global.hud.say("As you stumble to ground, the enemy is quickly all over you to bind you with its tentacles.")
	Global.hud.show_picture_right(load("res://assets/images/chars/Crab.png"))
	return 1

func lustTrigger()->int:
	Global.hud.say("Just by having those tentacles tickle all over your sensitive part you get to cum.")
	return 1
