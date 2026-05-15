extends Recipe

func getCheck()->Array[CondCheck.Cond_Base]:
	return [CondCheck.Cond_Resource.create("net_broken",1)]

func getID()->String:
	return "thread_rough"

#override this
func getItemID()->String:
	return "thread_rough"
	
#override this
func getName()->String:
	return "rough thread"

#override this
func getDescription()->String:
	return "sturdy threads"

func getTags()->Array:
	return ["Backpack"]
	

var amount:int=3
