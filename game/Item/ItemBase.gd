extends Node
class_name ItemBase

const ITEM_TAG = {Consumable=1,
	Ingredient = 2, 
	Weapon_Melee=3,
	Weapon_Ranged=4,
	Weapon_Throw=5,
	Shield=6,
	Tool_Cut=7,
	Quest=100   }

const EQUIP_TAG = { None=0,
	Hand_Right=1,
	Hand_Left=2,
	Hand_Both=3,
	Hand_Any=4,
	Feet=11,
	Torso=12,
	Legs=13,
	Arms=14,
	Head=15,
	Neck=16,
}

var uniqueID:int = -1
var id:String = "Unknown"
var currentInventory:Inventory
var amount:int = 1

#override this !
func _init():
	pass

#override this !
func getTags()->Array:
	return []
	
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
	return id

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

func canUseInCombat():
	return false

# gives a list of actions when in inventory-ui
func getPossibleActions():
	return [ ]
		#{	"name": "Charge it!",
			#"scene": "UseItemLikeInCombatScene",
			#"description": "Charge the thing",
		#}
	

func getPrice():
	return 30
	
func destroyMe():
	if(currentInventory == null):
		return
	currentInventory.removeItem(self)
	currentInventory.removeEquippedItem(self)

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
		"ID": id,
		"cnt": amount,
	}
	return(data)
