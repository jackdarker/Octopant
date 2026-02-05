class_name Effect extends Node

# some temporary effect applied to character

signal changed(ID:String)	#! you need to send changed to update UI
#onApply,onRemove,onFightStart,onFightEnd also onProcessTime and onCombatProcessTurn if some value is modified

enum HIDE {NONE=0, NAME=1, VALUE=2, DURATION=4, ALL=255}	#bitmask !


var ID:String="UNKNOWN"
var uniqueID:int = -1
var character:Character=null
var hidden:int=0
var timeStart:int		#when the effect was first applied
var timeLast:int = 0	#the last time the effect was executed again
var timeDelta:int = 0	#incremental count of seconds since timeLast

var duration:int = 60*60	#after this time remove the effect; in turn for combat else in s

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

#override ! see examples for details	
#dont use Global.main.getTime() as it might not have updated yet!
#_delta might be any time-length, you need to scale your status-change by this length!
func processTime(_delta:int):
	pass

#override!  if this effect is already present we can modify it or replace it with the new
func combine(_newEffect:Effect)->Effect:
	return self

func applyTo(_char:Character):
	character=_char
	character.effects.addItem(self)
	self.timeStart=Global.main.getTime()
	self.timeLast=timeStart
	onApply()

func onApply():
	changed.emit(ID)
	pass

func onRemove():
	changed.emit(ID)
	pass

# you can call destroyMe or list.removeItem, it will passby here anyway
var __destroyInProcess:int=0
func destroyMe():
	if __destroyInProcess<=0:
		onRemove()
		__destroyInProcess=1
		character.effects.removeItem(self)
		changed.emit(ID)
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
