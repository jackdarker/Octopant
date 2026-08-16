extends EventBase

# an event that gives the player some cloths if he has none
# only when no cloths in inventory & outfit

func _init():
	ID="EventFindLootBasicCloths"
	super()

func react(_triggerID,_location,_args)->bool:
	Global.hud.clearInput()
	Global.hud.say("You stumble about a bundle of wrapped up cloths.")
	Global.hud.addButton("Ignore it","",_ignore,func(): return(Result.create(false,"some cloths are better then none")))
	Global.hud.addButton("Dress up","",_dressUp,null)
	return true
	
func canRun(_trigger,_location,_args)->bool:
	return (_players_cloths().count(0)>0)	#only when no cloth for upper or lower


func _ignore():
	Global.hud.say("\n")
	Global.main.getCurrentScene().continueScene()
	pass

func _players_cloths()->Array:
	var _wear:Array[EquipmentBase]=Global.pc.outfit.getItems()
	var _items=Inventory.filter_by_tag(Global.pc.inventory.getItems(),[ItemTagEnum.Wear])
	for _item in _items:
		if(_item is EquipmentBase):
			_wear.push_back(_item)
	
	var _wearUpper:Array[EquipmentBase]=Outfit.filter_by_slotuse(_wear,[BodySlotEnum.Hips])
	var _wearLower:Array[EquipmentBase]=Outfit.filter_by_slotuse(_wear,[BodySlotEnum.Legs])
	
	return([_wearUpper.size(),_wearLower.size()])

func _dressUp():
	var i=randi_range(0, 100)
	var _wear:Array=_players_cloths()
	
	if(_wear[0]<=0):
		var _item=GR.createItem("shirt_plain")
		Global.hud.say("You found some [b]shirt[/b].")
		Global.hud.show_picture_center(load(_item.getInventoryImage()))
		Global.pc.outfit.addItem(_item)
	if(_wear[1]<=0):
		var _item=GR.createItem("shorts_plain")
		Global.hud.say("You found some [b]shorts[/b].")
		Global.hud.show_picture_center(load(_item.getInventoryImage()))
		Global.pc.outfit.addItem(_item)
	if(_wear[0]>0 || _wear[1]>0):
		Global.hud.say("But they look worse then what you already have.")
	Global.main.getCurrentScene().continueScene()
