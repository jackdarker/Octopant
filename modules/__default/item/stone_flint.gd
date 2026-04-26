extends ItemBase

func _init():
	super()
	ID="flint"
	tags=[ItemTagEnum.Ingredient_Craft]


func getName()->String:
	return "flint stone"

func getDescription()->String:
	return "A small, hard stone. Creates sparks if slapped against metal."
