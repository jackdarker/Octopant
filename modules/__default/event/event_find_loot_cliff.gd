extends EventBase

# an event that gives the player some loot

func _init():
	super()
	ID="EventFindLootCliff"

func react(_triggerID, _args)->bool:
	var i=randi_range(0, 100)
	if(i>50):
		Global.hud.say("There's a rock that looks a little unusual. It's much harder and appears to be made up of several shell-like layers.")
		Global.hud.addButton("It's a rock, who cares","",_ignore,null)
		if(false):
			Global.hud.addButton("Take it","",_take_flint,null)
	else:
		Global.hud.say("Nothing was found")
		Global.hud.addButton("Move on","",_ignore,null)
		
	return true
	
func canRun()->bool:
	return true

func _ignore():
	Global.hud.say("\n")
	Global.main.getCurrentScene().continueScene()
	pass

func _take_flint():
	var _item=GR.createItem("stone_flint")
	Global.hud.say("You pickup the [b]flint stone[/b].")
	Global.hud.show_picture_center(load(_item.getInventoryImage()))
	Global.pc.inventory.addItem(_item)
	Global.main.getCurrentScene().continueScene()
