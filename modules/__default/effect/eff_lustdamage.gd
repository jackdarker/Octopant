class_name effLustDamage extends Effect

var type:String

func _init():
	ID="eff_lustdamage"
	duration=0
	magnitude=5
	type="tease"

func getName()->String:
	return("lustdamage")

# combat-only effects are removed post-combat
func isCombatOnly()->bool:
	return true

func processCombatTurn(_contex = {}):
	user.status.getItemByID(StatEnum.Lust).modify(magnitude)
	#todo this.castMsg=window.gm.util.descFixer(this.parent.parent)(this.amount+' '+this.data.name+' '); //'$[Name]$ got hurt for '+  
   
	timeLast=timeDelta+timeLast
	duration-=1
	changed.emit(ID)
	
	if duration<=0:
		destroyMe()
	
func onFightEnd(_contex = {}):
	destroyMe()
	
	
func getDescription()->String:
	return("increase lust")
