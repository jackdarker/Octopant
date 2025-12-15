extends Node
class_name ItemBase

const ITEM_TAG = {Consumable=1,Ingredient = 2, Weapon_Melee=3 }

var currentInventory:Inventory

#override this !
func getTags()->Array:
	return []

func getName()->String:
	return "Unknown"

func getUID()-> int:
	return 0

func getInventoryImage():
	return "res://Images/Items/weapon/shiv.png"   #TODO

func canUseInCombat():
	return false

func getPossibleActions():
	return [
		{
			"name": "Charge it!",
			"scene": "UseItemLikeInCombatScene",
			"description": "Charge the thing",
		}, #TODO use on self
	]

func getPrice():
	return 30
	
func destroyMe():
	if(currentInventory == null):
		return
	currentInventory.removeItem(self)
	currentInventory.removeEquippedItem(self)

func useCharge(amount = 1):
	charges -= amount
	if(charges <= 0):
		charges = 0
		#destroyMe()

func getCharges():
	return 0

func getDamageRange():
	return [20, 40]
