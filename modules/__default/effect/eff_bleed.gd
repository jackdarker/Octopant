extends Effect

func _init():
	ID="eff_bleed"
	duration=3

# combat-only effects are removed post-combat
func isCombatOnly()->bool:
	return true

func processCombatTurn(_contex = {}):
	@warning_ignore("integer_division")
	character.status.getItemByID(StatEnum.Pain).modify(5)
	timeLast=timeDelta+timeLast
	duration-=1
	changed.emit(ID)
	
	if duration<=0:
		destroyMe()
	
func onFightStart(_contex = {}):
	pass

func onFightEnd(_contex = {}):
	destroyMe()
	
	
func onApply():
	changed.emit(ID)
	
func combine(_newEffect:Effect)->Effect:
	self.duration+=_newEffect.duration
	return self
	
func getDescription()->String:
	return("bleeding for "+str(duration)+" turns")
