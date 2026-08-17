extends Character


func _init():
	super()
	getStat(StatEnum.Pain).ul=20
	getStat(StatEnum.rst_tease).value=100
	getStat(StatEnum.rst_physical).value=50
	self.ID="Crab"
	self.combatAI=CombatAIBase.new()
	self.combatAI.char=self

func getBustImage()->Texture2D:
	return load("res://assets/images/chars/Crab.png")
