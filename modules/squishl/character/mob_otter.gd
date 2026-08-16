class_name MobOtter extends Character


func _init():
	super()
	getStat(StatEnum.Pain).ul=120
	getStat(StatEnum.Lust).ul=30
	self.ID="Otter"
	self.combatAI=CombatAIBase.new()
	self.combatAI.char=self
	skills.addItem(GR.createSkill("Skill_Heal"))
	skills.addItem(GR.createSkill("Skill_Tease"))

func getBustImage()->Texture2D:
	return load("res://assets/images/chars/otter.png")
