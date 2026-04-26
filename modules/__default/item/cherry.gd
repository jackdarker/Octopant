extends ItemBase

func _init():
	super()
	ID="cherry"
	tags.push_back(ItemTagEnum.Consumable)

func getName()->String:
	return "cherry"

func getDescription()->String:
	return "Some cherrys"

func getInventoryImage():
	return "res://assets/images/items/Fruit_Cherry.svg"

func getPossibleActions():
	return [ 
		{	"name": "eat",
			"description": "eat it",
		}]
		
func canDo(action,_target)->Result:
	if(action=="eat"):
		return Result.create(true,"")
	else:
		return (Result.create(false,""))

func doAction(action:String,target):
	if(action=="eat"):
		if target is Character:
			pass
		self.destroyMe()
	
