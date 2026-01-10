extends Node
class_name Character

signal stat_changed

var location:String = ""

var statuslist:StatusList
var inventory: Inventory

func _init():
	inventory=Inventory.new()
	statuslist=StatusList.new()
	statuslist.addItem(Status.create("pain",0))
	statuslist.addItem(Status.create("fatigue",0))

func getStat(key)->Status:
	return statuslist.getItemByID(key)

func loadData(data):
	location=data["location"]
	inventory.loadData(data["inv"])
	statuslist.loadData((data["status"]))
			
func saveData()->Variant:
	var data ={
		"location":location,
		"inv":inventory.saveData(),
		"status":statuslist.saveData()
	}
	return(data)
