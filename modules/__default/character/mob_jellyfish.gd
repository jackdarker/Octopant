extends Character


func _init():
	super()
	getStat(StatEnum.Pain).ul=20
	self.ID="JellyFish"
	self.combatAI=CombatAIBase.new()
	self.combatAI.char=self
	skills.addItem(GR.createSkill("Skill_Paralyse"))

func getBustImage()->Texture2D:
	return load("res://assets/images/chars/JellyFish.png")
