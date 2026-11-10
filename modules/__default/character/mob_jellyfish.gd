extends Character


func _init():
	super()
	getStat(StatEnum.Pain).ul=20
	self.ID="JellyFish"
	self.combatAI=CombatAIBase.new()
	self.combatAI.char=self
	self.combatAI.combat_beh=["Skill_Attack","Skill_Attack","Skill_Trip","Skill_Trip"]
	self.combatAI.grapple_beh=["Skill_Grope","Skill_Grope"]
	skills.addItem(GR.createSkill("Skill_Attack"))
	skills.addItem(GR.createSkill("Skill_Trip"))
	skills.addItem(GR.createSkill("Skill_Special"))
	skills.addItem(GR.createSkill("Skill_Grope"))

func getBustImage()->Texture2D:
	return load("res://assets/images/chars/JellyFish.png")
