extends Recipe

func getCheck()->Array[CondCheck.Cond_Base]:
	return [CondCheck.Cond_Resource.create("seashell",1),
	CondCheck.Cond_Resource.create("gel_green",1)]

func getID()->String:
	return "knife_seashell"

#override this
func getItemID()->String:
	return "knife_seashell"
	
#override this
func getName()->String:
	return "seashell-knife"

#override this
func getDescription()->String:
	return "a very simple knife made from seashell"

func getTags()->Array:
	return ["Weapon","Backpack"]
	

var amount:int=1
