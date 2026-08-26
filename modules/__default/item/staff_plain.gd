extends EquipmentBase

func _init():
	super()
	ID="staff_plain"
	tags=[ItemTagEnum.Weapon_Melee]
	slotUse=[BodySlotEnum.RHand]

func getDescription()->String:
	return("This is basically just some stick as long as your arm.")

#override this !
func getInventoryImage()->String:
	return "res://assets/images/items/Staff_Wood.svg"


func attackMod(target:Character)->AttackData:
	var mod=AttackData.create()
	mod.onHit=[{"target":target,"eff": [effDamage.create(15)]}]
	return mod

func equip(target:Character)->Result:
	var _res=super(target)
	user.skills.addItem(GR.createSkill("Skill_Strike"))
	return _res

func unequip()->Result:
	user.skills.removeItemID("Skill_Strike")
	return super()
	
