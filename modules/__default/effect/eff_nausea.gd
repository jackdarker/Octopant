extends Effect

func _init():
	ID="eff_nausea"
	duration=8*60*60

func getName()->String:
	return("nauseous")

func processTime(_delta:int):
	timeDelta=timeDelta+_delta
	if(timeDelta>=3600):	#tick every 1h
		@warning_ignore("integer_division")
		user.status.getItemByID(StatEnum.Pain).modify(10*timeDelta/3600)
		timeLast=timeDelta+timeLast
		duration-=timeDelta
		timeDelta=0
		changed.emit(ID)
		
	if duration<=0:
		destroyMe()
		return
	
func getDescription()->String:
	return("Feeling a little sick")
