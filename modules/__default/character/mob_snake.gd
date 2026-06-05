extends Character


func _init():
	super()
	getStat(StatEnum.Pain).ul=20
	self.ID="Snake"
	self.combatAI=CombatAIBase.new()
	self.combatAI.char=self
	skills.addItem(GR.createSkill("Skill_Blind"))

func getBustImage()->Texture2D:
	return load("res://assets/images/chars/snake_tree.png")
