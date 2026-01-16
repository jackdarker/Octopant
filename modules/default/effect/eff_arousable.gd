extends Effect

func _init():
	ID="eff_arousable"

func processTime(_delta:int):
	timeDelta=timeDelta+_delta
	if(timeDelta>=3600):	#tick every 1h
		character.statuslist.getItemByID(StatEnum.Lust).modify(5*timeDelta/3600)
		timeLast=timeDelta+timeLast
		duration-=timeDelta
		timeDelta=0
		changed.emit(ID)
		
	if duration<=0:
		destroyMe()
		return
	
	
func onApply():
	self.duration=3*60*60
	changed.emit(ID)

func getDescription()->String:
	return("easy to tease")
