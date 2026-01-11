class_name Effect extends Node

# some temporary effect applied to character

var ID:String="UNKNOWN"
var uniqueID:int = -1
var character:Character=null
var timeStart:int
var timeDelta:int = 0
var timeLast:int = 0
var duration:int = 60*60

#override this !
func _init():
	pass

#override this !
func getName()->String:
	return (self.getID())

#override this !
func getDescription()->String:
	return ("some "+getName())

func getUID()-> int:
	return uniqueID
	
func getID()-> String:
	return ID

#override this !
func getIcon()->StringName:
	return "res://assets/images/icons/ic_unknown.svg"

func getIconColor()->Color:
	return Color.GRAY

# combat-only effects are removed post-combat
func isCombatOnly()->bool:
	return false

func processCombatTurn(_contex = {}):
	pass
	
func onFightStart(_contex = {}):
	pass

func onFightEnd(_contex = {}):
	pass
	
func processTime(_delta:int):
	pass

func combine(_newEffect:Effect):
	pass

func applyTo(_char:Character):
	character=_char
	character.effectlist.addItem(self)
	self.timeStart=Global.main.getTime()
	onApply()

func onApply():
	pass

func onRemove():
	pass

func destroyMe():
	onRemove()
	character.effectlist.removeItem(self)
	queue_free()

func loadData(data):
	uniqueID=data["UID"]
	timeStart=data["start"]
	duration=data["duration"]
	timeLast=data["timeLast"]
	timeDelta=data["timeDelta"]
	pass
			
func saveData()->Variant:
	var data ={	
		#"item":self.get_script().resource_path,	#get_script().get_global_name(),
		#"scene" : get_scene_file_path(),
		#"parent" : get_parent().get_path(),
		"UID":uniqueID,
		"start":timeStart,
		"duration":duration,
		"timeLast":timeLast,
		"timeDelta":timeDelta
	}
	return(data)
