extends Node
class_name Character

var location:String = ""

var statuslist:StatusList
var effectlist:EffectsList
var inventory:Inventory
var outfit:Outfit

func _init():
	inventory=Inventory.new()
	outfit=Outfit.new()
	outfit.wrefCharacter=weakref(self)
	statuslist=StatusList.new()
	statuslist.addItem(Status.create("pain",0,0,60))
	statuslist.addItem(Status.create("fatigue",0,0,100))
	statuslist.addItem(Status.create("lust",0,0,60))
	effectlist=EffectsList.new()

func getStat(key)->Status:
	return statuslist.getItemByID(key)

func processTime(_delta:int):
	for item in effectlist.getItems():
		item.processTime(_delta)

func loadData(data):
	location=data["location"]
	inventory.loadData(data["inv"])
	outfit.loadData(data["outfit"])
	statuslist.loadData((data["status"]))
			
func saveData()->Variant:
	var data ={
		"location":location,
		"inv":inventory.saveData(),
		"outfit":outfit.saveData(),
		"status":statuslist.saveData()
	}
	return(data)
