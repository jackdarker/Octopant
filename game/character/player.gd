class_name Player extends Character


func _init():
	super()
	self.ID="Player"
	isPlayer=true

	status.addItem(Status.create(StatEnum.Insanity,0,-9999,9999))	#TODO those stats only for player?
	for item in [StatusDefault.StatStrength.new(),StatusDefault.StatAgility.new(),StatusDefault.StatIntellect.new()]:
		item.base=20
		status.addItem(item)
	#self.skills.addItem(GR.createSkill("Skill_Slash"))
	self.skills.addItem(GR.createSkill("Skill_Cleave"))
	self.skills.addItem(GR.createSkill("Skill_Tease"))
	self.skills.addItem(GR.createSkill("Skill_Submit"))

func post_sleep():
	getStat(StatEnum.Pain).modify(-99999)
	getStat(StatEnum.Fatigue).modify(-99999)
	getStat(StatEnum.Lust).modify(getStat(StatEnum.Lust).value*-0.5)
	GR.createEffect("eff_slept").applyTo(self)
	
func getBustImage()->Texture2D:
	return load("res://assets/images/chars/bust_pc_start.png")
