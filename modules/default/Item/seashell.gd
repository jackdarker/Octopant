extends ItemBase

func _init():
	super()
	id="seashell"

func getTags()->Array:
	return [ITEM_TAG.Ingredient]

func getDescription()->String:
	return "A pretty looking shell. If broken into pieces, their sharp edges can be used for cutting things."

func getPossibleActions():
	return [ 
		{	"name": "break it!",
			"scene": "UseItemLikeInCombatScene",
			"description": "Dont cut yourself!",
		}]
