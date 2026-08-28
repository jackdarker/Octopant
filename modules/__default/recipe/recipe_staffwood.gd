extends Recipe

var amount:int=1

func getCheck()->Array[CondCheck.Cond_Base]:
	return [CondCheck.Cond_Resource.create("twig",1),
	CondCheck.Cond_Resource.create("thread_rough",2)]


#override this
func getItemID()->String:
	return "staff_plain"
	
#override this
func getName()->String:
	return "wodden staff"

#override this
func getDescription()->String:
	return "a club made from a branch"

func getTags()->Array:
	return ["Weapon","Backpack"]
