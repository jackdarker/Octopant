extends Recipe

var amount:int=1

func getCheck()->Array[CondCheck.Cond_Base]:
	return [CondCheck.Cond_Resource.create("staff_plain",1),
	CondCheck.Cond_Resource.create("thread_rough",2),
	CondCheck.Cond_Resource.create("gel_green",2),
	CondCheck.Cond_Resource.create("stone_flint",1)
	]

#override this
func getItemID()->String:
	return "spear_stone"
	
#override this
func getName()->String:
	return "wodden spear"

#override this
func getDescription()->String:
	return "wodden spear with stone tip"

func getTags()->Array:
	return ["Weapon","Backpack"]
