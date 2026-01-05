extends Node
class_name Character

signal stat_changed

var location:String = ""

var statusEffects:Dictionary = {}
var inventory: Inventory

var pain:int = 0
var painMax:int = 50

var fatigue:int = 0
var fatigueMax:int = 50

func _init():
	inventory=Inventory.new()

func loadData(data):
	location=data["location"]
			
func saveData()->Variant:
	var data ={
		"location":location,
	}
		
	return(data)
