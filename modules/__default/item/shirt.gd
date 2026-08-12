extends EquipmentBase

func _init():
	super()
	ID="shirt_plain"
	tags=[ItemTagEnum.Wear]
	slotUse=[BodySlotEnum.Belly,BodySlotEnum.Breast]

func getDescription()->String:
	return "A simple - and slightly stained - cotton shirt."
