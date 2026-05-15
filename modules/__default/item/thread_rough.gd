extends ItemBase

func _init():
	super()
	ID="thread_rough"
	tags=[ItemTagEnum.Ingredient_Craft]

func getInventoryImage():
	return "res://assets/images/items/Thread_S_Blue.svg"

func getName()->String:
	return "a short thread"

func getDescription()->String:
	return "a short but sturdy thread."

func canStack()->bool:
	return true
