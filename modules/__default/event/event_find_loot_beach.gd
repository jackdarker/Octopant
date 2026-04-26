extends EventBase

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
	if(i>70):
		var _item=GR.createItem("vial_empty")
		Global.hud.say("You found some [b]empty plastic bottle[/b].")
		Global.hud.show_picture_center(load(_item.getInventoryImage()))
		Global.pc.inventory.addItem(_item)
	elif(i>50):
		var _item=GR.createItem("net_broken")
		Global.hud.say("Embedded into the sand is a [b]piece of a net[/b], possibly ripped of from some fishing net.")
		Global.hud.show_picture_center(load(_item.getInventoryImage()))
		Global.pc.inventory.addItem(_item)
	elif(i>10):
		var _item=GR.createItem("seashell")
		Global.hud.say("You found a [b]pretty seaschell[/b].")
		Global.hud.show_picture_center(load(_item.getInventoryImage()))
		Global.pc.inventory.addItem(_item)
	else:
		Global.hud.say("There is nothing.")
	Global.main.getCurrentScene().continueScene()
	pass
