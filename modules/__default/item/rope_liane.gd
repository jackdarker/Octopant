extends ItemBase

func _init():
	super()
	ID="rope_liane"
	tags=[ItemTagEnum.Tool]

func getDescription()->String:
	return "several meters of rope"

func getInventoryImage():
	return "res://assets/images/items/Rope.svg"
