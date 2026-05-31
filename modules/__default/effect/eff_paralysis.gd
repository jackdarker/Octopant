extends Effect

func _init():
	ID="eff_paralyse"

func getName()->String:
	return("paralysed")

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
	
# combat-only effects are removed post-combat
func isCombatOnly()->bool:
	return true
	
func onFightEnd(_contex = {}):
	destroyMe()
	
func onApply():
	self.duration=2
	changed.emit(ID)

func getDescription()->String:
	return("stunned by paralysis")
