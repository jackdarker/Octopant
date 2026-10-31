class_name Player extends Character


func _init():
	super()
	self.ID="Player"
	isPlayer=true

	status.addItem(Status.create(StatEnum.Insanity,0,-9999,9999))	#TODO those stats only for player?
	status.addItem(Status.create(StatEnum.Poise,0,0,100))
	status.addItem(Status.create(StatEnum.Advantage,0,0,100))
	for item in [StatusDefault.StatStrength.new(),StatusDefault.StatAgility.new(),StatusDefault.StatIntellect.new()]:
		item.base=20
		status.addItem(item)
	self.skills.addItem(GR.createSkill("Skill_Attack"))
	self.skills.addItem(GR.createSkill("Skill_Posture"))
	self.skills.addItem(GR.createSkill("Skill_Block"))
	self.skills.addItem(GR.createSkill("Skill_Steady"))
	self.skills.addItem(GR.createSkill("Skill_Focus"))
	self.skills.addItem(GR.createSkill("Skill_Breakfree"))
	self.skills.addItem(GR.createSkill("Skill_Struggle"))
	self.skills.addItem(GR.createSkill("Skill_Submit"))

func post_sleep():
	getStat(StatEnum.Pain).modify(-99999)
	getStat(StatEnum.Fatigue).modify(-99999)
	getStat(StatEnum.Lust).modify(getStat(StatEnum.Lust).value*-0.5)
	GR.createEffect("eff_slept").applyTo(self)
	GR.createEffect("eff_hungry").applyTo(self)
	
func getBustImage()->Texture2D:
	return load("res://assets/images/chars/bust_pc_start.png")
