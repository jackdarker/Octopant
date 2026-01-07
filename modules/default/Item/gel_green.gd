extends ItemBase

func _init():
	super()
	id="gel_green"

func getTags()->Array:
	return [ITEM_TAG.Ingredient]

func getName()->String:
	return "green gel"

func getDescription()->String:
	return "Some suspicious green slime."

func getInventoryImage():
	return "res://assets/images/items/Gel_S_Green.svg"
