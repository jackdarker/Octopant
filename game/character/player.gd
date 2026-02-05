extends Character
class_name Player

func _init():
	super()
	self.ID="Player"
	self.skills.addItem(GlobalRegistry.createSkill("Skill_Slash"))

func post_sleep():
	getStat(StatEnum.Pain).modify(-99999)
	getStat(StatEnum.Fatigue).modify(-99999)
	GlobalRegistry.createEffect("eff_arousable").applyTo(self)
	
