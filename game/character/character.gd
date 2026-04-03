class_name Character extends Node

var location:String = ""
var faction:String = ""
var uniqueID:String = ""		#name on screen like crab #5
var ID:String = "Unknown":		# just crab
	set(value):
		if(ID!=value && value!=""):
			uniqueID=value
			ID=value
		
var status:StatusList
var effects:EffectsList
var inventory:Inventory
var outfit:Outfit
var skills:Inventory
var combatAI = null		#controlled by player if this is null
var despawn:bool=false	#this was spawned in combat and should despawn

func _init():
	inventory=Inventory.new()
	inventory.user=(self)
	outfit=Outfit.new()
	outfit.user=(self)
	status=StatusList.new()
	status.addItem(Status.create(StatEnum.Pain,0,0,60))
	status.addItem(Status.create(StatEnum.Fatigue,0,0,100))
	status.addItem(Status.create(StatEnum.Lust,0,0,60))
	effects=EffectsList.new()
	effects.user=(self)
	skills= Inventory.new()
	skills.user=(self)
	skills.addItem(GR.createSkill("Skill_Punch"))
	
func getName()->String:
	return (uniqueID)

#override this !
func getBustImage()->String:
	return "res://assets/images/icons/ic_unknown.svg"


func getStat(key)->Status:
	return status.getItemByID(key)

# dead or passed out
func isKnockedOut()->bool:
	if(getStat(StatEnum.Pain).atUL):
		return(true)
	if(getStat(StatEnum.Lust).atUL):
		return(true)
		
	return(false)


func processTime(_delta:int):
	for item in effects.getItems():
		item.processTime(_delta)

func loadData(data):
	location=data["location"]
	ID=data["id"]
	uniqueID=data["uid"]
	inventory.loadData(data["inv"])
	outfit.loadData(data["outfit"])
	status.loadData(data["status"])
	effects.loadData(data["effects"])
			
func saveData()->Variant:
	var data ={
		"id":ID,
		"uid":uniqueID,
		"location":location,
		"inv":inventory.saveData(),
		"outfit":outfit.saveData(),
		"status":status.saveData(),
		"effects":effects.saveData(),
	}
	return(data)
