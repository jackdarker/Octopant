extends Character


func _init():
	super()
	getStat(StatEnum.Pain).ul=20
	self.ID="Crab"
	self.combatAI=CombatAIBase.new()
	self.combatAI.char=self

func getBustImage()->String:
	return("res://assets/images/chars/Crab.png")
