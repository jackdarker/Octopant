extends EventBase
class_name EventFindLootBeach

# an event that gives the player some loot

func _init():
	super()
	id="EventFindLootBeach"

func react(_triggerID, _args)->bool:
	Global.ui.say("There is something sparkling between seasshells")
	Global.ui.addButton("Ignore it","",_ignore,null)
	Global.ui.addButton("Dig it out","",_dig,null)
	return true
	
func canRun()->bool:
	return true

func _ignore():
	Global.ui.say("\n")
	Global.main.getCurrentScene().continueScene()
	pass

func _dig():
	var i=randi_range(0, 100)
	if(i>50):
		Global.ui.say("You found some empty glass-vial.")
		Global.pc.inventory.addItem(GlobalRegistry.createItem("vial_empty"))
	elif(i>10):
		Global.ui.say("You found a pretty seaschell.")
		Global.pc.inventory.addItem(GlobalRegistry.createItem("seashell"))
	else:
		Global.ui.say("There is nothing.")
	Global.main.getCurrentScene().continueScene()
	pass
