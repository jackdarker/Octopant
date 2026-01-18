extends ItemBase

func _init():
	super()
	ID="seashell"
	tags.push_back(ItemTagEnum.Ingredient)

func getDescription()->String:
	return "A pretty looking shell. If broken into pieces, their sharp edges can be used for cutting things."

func getPossibleActions():
	return [ 
		{	"name": "break it!",
			"scene": "UseItemLikeInCombatScene",
			"description": "Dont cut yourself!",
		}]
