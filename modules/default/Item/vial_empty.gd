extends ItemBase

func _init():
	super()
	id="vial_empty"

func getTags()->Array:
	return [ITEM_TAG.Ingredient]

func getName()->String:
	return "empty vial"

func getDescription()->String:
	return "A small vial. Could be used to hold some liquid."
