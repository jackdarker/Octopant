extends Effect

func _init():
	ID="eff_slept"
	self.duration=3*60*60

func getName()->String:
	return("well rested")

func processTime(_delta:int):
	timeDelta=timeDelta+_delta
	if(timeDelta>=3600):	#tick every 1h
		#TODO improved stats?
		#@warning_ignore("integer_division")
		#user.status.getItemByID(StatEnum.Lust).modify(15*timeDelta/3600)
		timeLast=timeDelta+timeLast
		duration-=timeDelta
		timeDelta=0
		#changed.emit(ID)
		
	if duration<=0:
		destroyMe()
		return
	

func getDescription()->String:
	return("well rested")
