extends ItemBase

func _init():
	super()
	ID="gel_green"
	tags.push_back(ItemTagEnum.Ingredient_Craft)

func getName()->String:
	return "green gel"

func getDescription()->String:
	return "Some suspicious green slime."

func getInventoryImage():
	return "res://assets/images/items/Gel_S_Green.svg"

func getPossibleActions():
	return [{	"name": "eat",
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
			var _eff=GR.createEffect("eff_nausea")
			_eff.applyTo(target)
		self.amount-=1

func canStack()->bool:
	return true
