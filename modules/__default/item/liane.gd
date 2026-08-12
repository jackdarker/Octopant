extends ItemBase

func _init():
	super()
	ID="liane"
	tags=[ItemTagEnum.Ingredient_Craft]

func getName()->String:
	return "a length of liane"

func getDescription()->String:
	return "Some meters of a sturdy liane."

func canStack()->bool:
	return true
