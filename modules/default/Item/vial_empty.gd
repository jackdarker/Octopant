extends ItemBase

func _init():
	super()
	id="vial_empty"

func getTags()->Array:
	return [ITEM_TAG.Ingredient]
