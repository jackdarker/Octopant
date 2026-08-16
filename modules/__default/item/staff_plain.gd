extends EquipmentBase

func _init():
	super()
	ID="staff_plain"
	tags=[ItemTagEnum.Weapon_Melee]
	slotUse=[BodySlotEnum.RHand]

func getDescription()->String:
	return("This is basically just some stick as long as your arm.")
