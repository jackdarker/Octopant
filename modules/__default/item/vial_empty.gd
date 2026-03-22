extends ItemBase

func _init():
	super()
	ID="vial_empty"
	tags.push_back(ItemTagEnum.Ingredient)

func getName()->String:
	return "empty vial"

func getDescription()->String:
	return "A small vial. Could be used to hold some liquid."

func getInventoryImage():
	return "res://assets/images/items/Drink_S_Empty.svg"
