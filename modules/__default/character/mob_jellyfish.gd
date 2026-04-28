extends Character


func _init():
	super()
	self.ID="JellyFish"
	self.combatAI=CombatAIBase.new()
	self.combatAI.char=self

func getBustImage()->String:
	return("res://assets/images/chars/JellyFish.png")
