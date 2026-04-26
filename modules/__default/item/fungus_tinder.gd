extends ItemBase

func _init():
	super()
	ID="fungus_tinder"
	tags=[ItemTagEnum.Ingredient_Craft]

func getName()->String:
	return "tinder fungus"

func getDescription()->String:
	return "good material to start a fire"
