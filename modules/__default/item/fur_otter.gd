extends ItemBase

func _init():
	super()
	ID="fur_otter"
	tags=[ItemTagEnum.Ingredient_Craft]

func getName()->String:
	return "otter fur"

func getDescription()->String:
	return "Tuft of fur from some otter."

func canStack()->bool:
	return true
