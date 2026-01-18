extends ItemBase

func _init():
	super()
	ID="gel_green"
	tags.push_back(ItemTagEnum.Ingredient)

func getName()->String:
	return "green gel"

func getDescription()->String:
	return "Some suspicious green slime."

func getInventoryImage():
	return "res://assets/images/items/Gel_S_Green.svg"

func getPossibleActions():
	return [ 
		{	"name": "eat",
			"scene": "UseItemLikeInCombatScene",
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
			var _eff=GlobalRegistry.createEffect("eff_nausea")
			_eff.applyTo(target)
		self.destroyMe()
