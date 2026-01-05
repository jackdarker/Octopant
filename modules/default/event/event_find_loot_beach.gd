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
	Global.ui.say("You found some empty glass-vial.")
	Global.pc.inventory.addItem(GlobalRegistry.createItem("vial_empty"))
	Global.main.getCurrentScene().continueScene()
	pass
