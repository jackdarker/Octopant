extends EventBase

# an event that gives the player some loot

func _init():
	ID="EventFindLootForest"
	super()


func react(_triggerID,_location,_args)->bool:
	Global.hud.clearInput()
	var i=randi_range(0, 100)
	if(i>60):
		Global.hud.say("You find some branch that could be used as a weapon.")
		Global.hud.addButton("Ignore it","",_ignore,null)
		Global.hud.addButton("Take it","",_take_branch)
	elif(i>30):
		Global.hud.say("Some lianes are dangling down from the branches of some trees.\nWith some tool you could cut them and use them for rope.")
		Global.hud.addButton("Ignore it","",_ignore,null)
		Global.hud.addButton("Cut them","",_cut_lianes,_can_cut)
	else:
		Global.hud.say("Nothing was found")
		Global.hud.addButton("Move on","",_ignore,null)
		
	return true
	
func canRun(_trigger,_location,_args)->bool:
	return true

func _ignore():
	Global.hud.say("\n")
	Global.main.getCurrentScene().continueScene()
	pass

func _can_cut()->Result:
	var _res:Result=Result.create(true,"")
	var _items=Inventory.filter_by_tag(Global.pc.inventory.getItems(),[ItemTagEnum.Tool_Cut])
	var _items2=Inventory.filter_by_tag(Global.pc.outfit.getItems(),[ItemTagEnum.Tool_Cut])
	if((_items2.size()+_items.size())<=0):
		_res.OK=false
		_res.Msg="Without a knife or something similiar you cant cut those lianes."
		Global.QS.start_quest(GR.getQuest("craft_knife"))
	return _res

func _cut_lianes():
	var i=randi_range(0, 100)
	if(i>10):
		var _item=GR.createItem("liane")
		Global.hud.say("Cutting some [b]liane[/b].")
		Global.hud.show_picture_center(load(_item.getInventoryImage()))
		Global.pc.inventory.addItem(_item)
		Global.main.getCurrentScene().continueScene()
	else:
		Global.hud.say("Damit, its not a liane but a snake !")
		var _setup=CombatSetup.new()
		_setup.playerParty.push_back(Global.pc)
		_setup.enemyParty.push_back(GR.createCharacter("Snake"))
		Global.main.runScene("combat_scene",[_setup],Global.main.currentSceneUID)
	pass

func _take_branch():
	var _item=GR.createItem("twig")
	Global.hud.say("Taking the [b]stick[/b], you might need to equip it.")
	Global.hud.show_picture_center(load(_item.getInventoryImage()))
	Global.pc.inventory.addItem(_item)
	Global.main.getCurrentScene().continueScene()
