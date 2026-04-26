extends Character


func _init():
	super()
	self.ID="Crab"
	self.combatAI=CombatAIBase.new()
	self.combatAI.char=self

func getBustImage()->String:
	return("res://assets/images/chars/spider1.svg")
