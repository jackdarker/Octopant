extends ItemBase

func _init():
	super()
	ID="net_broken"
	tags=[ItemTagEnum.Ingredient_Craft]

func getName()->String:
	return "damaged net"

func getDescription()->String:
	return "A piece of fishing net. Break down for threads."
