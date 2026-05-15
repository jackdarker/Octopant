extends Character


func _init():
	super()
	getStat(StatEnum.Pain).ul=120
	self.ID="Lizardman"
	self.combatAI=CombatAIBase.new()
	self.combatAI.char=self

func getBustImage()->String:
	return("res://assets/images/chars/lizardman.png")
