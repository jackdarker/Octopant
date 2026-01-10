extends ItemBase

func _init():
	super()
	id="vial_pink"

func getTags()->Array:
	return [ITEM_TAG.Ingredient]

func getName()->String:
	return "pink vial"

func getDescription()->String:
	return "A small vial containing pink liquid."

func getInventoryImage():
	return "res://assets/images/items/Drink_S_Pink.svg"

func getPossibleActions():
	return [ 
		{	"name": "drink",
			"scene": "UseItemLikeInCombatScene",
			"description": "drink it",
		}]
		
func canDo(action,target)->Result:
	if(action=="drink"):
		return Result.create(true,"")
	else:
		return (Result.create(false,""))

func doAction(action:String,target):
	if(action=="drink"):
		if target is Character:
			target
		self.destroyMe()
	
