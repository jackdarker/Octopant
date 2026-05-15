extends Recipe

func getCheck()->Array[CondCheck.Cond_Base]:
	return [CondCheck.Cond_Resource.create("liane",3)]

func getID()->String:
	return "rope_liane"

#override this
func getItemID()->String:
	return "rope_liane"
	
#override this
func getName()->String:
	return "makeshift rope"

#override this
func getDescription()->String:
	return "a rope made vom intertwined lianes"

func getTags()->Array:
	return ["Backpack"]
	
var amount:int=1
