extends ItemBase

func _init():
	super()
	ID="vial_pink"
	tags.push_back(ItemTagEnum.Ingredient)

func getName()->String:
	return "pink vial"

func getDescription()->String:
	return "A small vial containing pink liquid."

func getInventoryImage():
	return "res://assets/images/items/Drink_S_Pink.svg"

func getPossibleActions():
	return [ 
		{	"name": "drink",
			"description": "drink it",
		}]
		
func canDo(action,_target)->Result:
	if(action=="drink"):
		return Result.create(true,"")
	else:
		return (Result.create(false,""))

func doAction(action:String,target):
	if(action=="drink"):
		if target is Character:
			pass
		self.destroyMe()
	
