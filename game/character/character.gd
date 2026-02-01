class_name Character extends Node

var location:String = ""
var faction:String = ""
var uniqueID:int = -1
var ID:String = "Unknown"
var status:StatusList
var effects:EffectsList
var inventory:Inventory
var outfit:Outfit
var skills:Inventory
var combatAI = null	#controlled by player if this is null

func _init():
	inventory=Inventory.new()
	inventory.user=(self)
	outfit=Outfit.new()
	outfit.wrefCharacter=weakref(self)
	status=StatusList.new()
	status.addItem(Status.create("pain",0,0,60))
	status.addItem(Status.create("fatigue",0,0,100))
	status.addItem(Status.create("lust",0,0,60))
	effects=EffectsList.new()
	skills= Inventory.new()
	skills.user=(self)
	skills.addItem(GlobalRegistry.createSkill("Skill_Punch"))
	
func getName()->String:
	return (ID)
	
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
	inventory.loadData(data["inv"])
	outfit.loadData(data["outfit"])
	status.loadData((data["status"]))
			
func saveData()->Variant:
	var data ={
		"location":location,
		"inv":inventory.saveData(),
		"outfit":outfit.saveData(),
		"status":status.saveData()
	}
	return(data)
