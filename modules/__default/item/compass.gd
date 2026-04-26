extends EquipmentBase

func _init():
	super()
	ID="compass"
	tags=[ItemTagEnum.Tool,ItemTagEnum.Quest]

func getName()->String:
	return "cheap compass"

func getDescription()->String:
	return "A cheap compass, but it seems to do it's job."
