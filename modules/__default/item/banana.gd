extends ItemBase

func _init():
	super()
	ID="banana"
	tags.push_back(ItemTagEnum.Consumable)

func getName()->String:
	return "banana"

func getDescription()->String:
	return "A yellow banana"

func getInventoryImage():
	return "res://assets/images/items/Fruit_Banana.svg"

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
			var eff=target.effects.getItemByID("eff_hungry")
			if(eff && eff.magnitude>10):
				user.status.getItemByID(StatEnum.Pain).modify(-10)
				user.status.getItemByID(StatEnum.Fatigue).modify(-10)
			eff=GR.createEffect("eff_hungry")
			eff.magnitude-=20
			target.effects.addItem(eff)

			pass
		self.amount-=1
	
func canStack()->bool:
	return true
