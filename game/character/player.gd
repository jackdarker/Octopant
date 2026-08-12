class_name Player extends Character

func _init():
	super()
	self.ID="Player"
	isPlayer=true
	status.addItem(Status.create(StatEnum.Insanity,0,-30,30))
	self.skills.addItem(GR.createSkill("Skill_Slash"))
	self.skills.addItem(GR.createSkill("Skill_Cleave"))

func post_sleep():
	getStat(StatEnum.Pain).modify(-99999)
	getStat(StatEnum.Fatigue).modify(-99999)
	getStat(StatEnum.Lust).modify(getStat(StatEnum.Lust).value*-0.5)
	GR.createEffect("eff_slept").applyTo(self)
	
func getBustImage()->Texture2D:
	return load("res://assets/images/chars/bust_pc_start.png")
