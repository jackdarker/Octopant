extends ItemBase

func _init():
	super()
	ID="twig"
	tags=[ItemTagEnum.Ingredient_Craft]

func getName()->String:
	return "twig"

func getDescription()->String:
	return "Some branch of a tree."

func canStack()->bool:
	return true
