class_name Player extends Character

func _init():
	super()
	self.ID="Player"
	status.addItem(Status.create(StatEnum.Insanity,0,-30,30))
	self.skills.addItem(GR.createSkill("Skill_Slash"))

func post_sleep():
	getStat(StatEnum.Pain).modify(-99999)
	getStat(StatEnum.Fatigue).modify(-99999)
	GR.createEffect("eff_arousable").applyTo(self)
	
func getBustImage()->String:
	return "res://assets/images/chars/bust_pc_start.png"
