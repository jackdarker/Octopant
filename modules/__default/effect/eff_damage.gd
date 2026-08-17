class_name effDamage extends Effect

var type:=""

func _init():
	ID="eff_damage"
	duration=0
	magnitude=10
	type="physical"

func getName()->String:
	return("damage")

# combat-only effects are removed post-combat
func isCombatOnly()->bool:
	return true

func processCombatTurn(_contex = {}):
	user.status.getItemByID(StatEnum.Pain).modify(magnitude)
	#todo this.castMsg=window.gm.util.descFixer(this.parent.parent)(this.amount+' '+this.data.name+' '); //'$[Name]$ got hurt for '+  
   
	timeLast=timeDelta+timeLast
	duration-=1
	changed.emit(ID)
	
	if duration<=0:
		destroyMe()
	
func onFightEnd(_contex = {}):
	destroyMe()
	
	
func getDescription()->String:
	return("physical damage")
