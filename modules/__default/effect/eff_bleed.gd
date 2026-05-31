extends Effect

func _init():
	ID="eff_bleed"
	duration=3

func getName()->String:
	return("bleeding")

# combat-only effects are removed post-combat
func isCombatOnly()->bool:
	return true

func processCombatTurn(_contex = {}):
	@warning_ignore("integer_division")
	user.status.getItemByID(StatEnum.Pain).modify(5)
	timeLast=timeDelta+timeLast
	duration-=1
	changed.emit(ID)
	
	if duration<=0:
		destroyMe()
	
func onFightEnd(_contex = {}):
	destroyMe()
	
	
func combine(_newEffect:Effect)->Effect:
	self.duration+=_newEffect.duration
	return self
	
func getDescription()->String:
	return("bleeding for "+str(duration)+" turns")
