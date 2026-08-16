class_name EffTrapped extends Effect

## this marks that the player is stuck in a trap and needs to struggle out of it

func _init():
	ID="eff_trapped"

func getName()->String:
	return("trapped")

func processTime(_delta:int):
	timeDelta=timeDelta+_delta
	if(timeDelta>=3600):	#tick every 1h
		@warning_ignore("integer_division")
		timeLast=timeDelta+timeLast
		duration-=timeDelta
		timeDelta=0
		changed.emit(ID)
		
	if duration<=0:
		destroyMe()
		return
	
	
func onApply():
	self.duration=24*60*7 # TODO
	changed.emit(ID)

func getDescription()->String:
	return("trapped")
