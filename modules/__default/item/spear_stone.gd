extends EquipmentBase

var _damage:=25.0

func _init():
	super()
	ID="spear_stone"
	tags=[ItemTagEnum.Weapon_Melee]
	slotUse=[BodySlotEnum.RHand]

func getDescription()->String:
	return("Culmination point of stick & stone technology. \nDMG: "+str(_damage))


func attackMod(target:Character)->AttackData:
	var mod=AttackData.create()
	mod.hitChance=80.0
	mod.onHit=[{"target":target,"eff": [effDamage.create(_damage)]}]
	return mod

func equip(target:Character)->Result:
	var _res=super(target)
	user.skills.addItem(GR.createSkill("Skill_Strike"))
	return _res

func unequip()->Result:
	user.skills.removeItemID("Skill_Strike")
	return super()
	
