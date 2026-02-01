extends EventBase
class_name EventFindLootBeach

# an event that gives the player some loot

func _init():
	super()
	ID="EventFindLootBeach"

func react(_triggerID, _args)->bool:
	Global.hud.say("There is something sparkling between seasshells")
	Global.hud.addButton("Ignore it","",_ignore,null)
	Global.hud.addButton("Dig it out","",_dig,null)
	return true
	
func canRun()->bool:
	return true

func _ignore():
	Global.hud.say("\n")
	Global.main.getCurrentScene().continueScene()
	pass

func _dig():
	var i=randi_range(0, 100)
	if(i>50):
		Global.hud.say("You found some empty glass-vial.")
		Global.pc.inventory.addItem(GlobalRegistry.createItem("vial_empty"))
	elif(i>10):
		Global.hud.say("You found a pretty seaschell.")
		Global.pc.inventory.addItem(GlobalRegistry.createItem("seashell"))
	else:
		Global.hud.say("There is nothing.")
	Global.main.getCurrentScene().continueScene()
	pass
