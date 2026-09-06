extends Effect

## magnitude equals hunger (100 is very hungry, 0 is completely sated)
## this effect is always present and is affected by combine()

func _init():
	ID="eff_hungry"
	magnitude=0

func getName()->String:
	return("hungry")
	
func getIcon()->StringName:
	return "res://assets/images/icons/ic_meal.svg"
	
func processTime(_delta:int):
	timeDelta=timeDelta+_delta
	if(timeDelta>=3600):	#tick every 1h
		magnitude=min(magnitude+10,100)
		timeLast=timeDelta+timeLast
		duration-=timeDelta
		timeDelta=0
		changed.emit(ID)

func combine(_newEffect:Effect)->Effect:
	magnitude = min(max(magnitude+_newEffect.magnitude,0),100)
	changed.emit(ID)
	return self

func getIconColor()->Color:
	if(magnitude>80):
		Tutorials.show("basic_hungry")
		return Effect.STATECOLOR.BAD
	if(magnitude>50):
		return Effect.STATECOLOR.MEDIUM
	if(magnitude>30):
		return Effect.STATECOLOR.GOOD
	return(Effect.STATECOLOR.NEUTRAL)

func getDescription()->String:
	if(magnitude>80):
		Tutorials.show("basic_hungry")
		return "very hungry"
	if(magnitude>50):
		return "quite hungry"
	if(magnitude>30):
		return "somewhat hungry"
	return("sated")
