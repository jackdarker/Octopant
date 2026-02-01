class_name ItemBase extends Node

#Note: this is also baseclass for skills and equip !

var uniqueID:int = -1
var ID:String = "Unknown"
var wrefInventory:WeakRef=null
var wrefCharacter:WeakRef=null 
var user:Character:
	set(value):
		wrefCharacter=weakref(value)
	get:
		return(wrefCharacter.get_ref())
		
var amount:int = 1:
	set(value):
		amount=value
		if(value<=0):
			destroyMe()
	get:
		return amount

var bonus:Array=[]	#buff or curses
var tags:Array=[]
		
#override this !
func _init():
	pass
	
func isEquipable()->bool:
	return (getEquipable().size()>0)
	
#override this !
func getEquipable()->Array:
	return []

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

func getTags()->Array:
	return tags


func hasTags(_tags:Array)->bool:
	var _res=true
	for tag in _tags:
		_res=_res && tags.has(tag)
	
	return(_res);


#override this !
func getInventoryImage():
	return "res://assets/images/icons/ic_unknown.svg"

#override this !
func canCombine():
	return false

#override this !	
func tryCombine(_otherItem):
	amount += _otherItem.amount
	return true

func canUseInCombat()->bool:
	return false

# gives a list of actions when in inventory-ui
func getPossibleActions():
	return [ ]
		#{	"name": "Charge it!",
			#"scene": "UseItemLikeInCombatScene",
			#"description": "Charge the thing",
		#}

#TODO target is always Character?
func canDo(_action:String,_target:Character)->Result:
	return (Result.create(false,""))

func doAction(_action:String,_target:Character):
	pass

func getPrice():
	return 30
	
func destroyMe():
	if(wrefInventory == null):
		return
	wrefInventory.get_ref().removeItem(self)

func useCharge(_amount = 1):
	#charges -= amount
	#if(charges <= 0):
	#	charges = 0
		#destroyMe()
	pass

func getCharges():
	return 0

func getDamageRange():
	return [20, 40]

func loadData(data):
	amount=data["cnt"]
	pass
			
func saveData()->Variant:
	var data ={	
		#"item":self.get_script().resource_path,	#get_script().get_global_name(),
		#"scene" : get_scene_file_path(),
		#"parent" : get_parent().get_path(),
		"UID":uniqueID,
		"ID": ID,
		"cnt": amount,
	}
	return(data)
