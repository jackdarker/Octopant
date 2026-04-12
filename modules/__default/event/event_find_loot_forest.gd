extends EventBase

# an event that gives the player some loot

func _init():
	super()
	ID="EventFindLootForest"

func react(_triggerID, _args)->bool:
	var i=randi_range(0, 100)
	if(i>50):
		Global.hud.say("Some lianes are dangling down from the branches of some trees.\n
		With some tool you could cut them and use them for rope.")
		Global.hud.addButton("Ignore it","",_ignore,null)
		Global.hud.addButton("Cut them","",_cut_lianes,_can_cut)
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

func _can_cut()->Result:
	var _res:Result=Result.create(true,"")
	var _items=Global.pc.inventory.filter_by_tag(Global.pc.inventory.getItems(),[ItemTagEnum.Tool_Cut])
	if(_items.size()<=0):
		_res.OK=false
		_res.Msg="Without a knife or something similiar you cant cut those lianes."
	return _res

func _cut_lianes():
	var i=randi_range(0, 100)
	if(i>10):
		var _item=GR.createItem("liane")
		Global.hud.say("Cutting some [b]liane[/b].")
		Global.hud.show_picture_center(load(_item.getInventoryImage()))
		Global.pc.inventory.addItem(_item)
	else:
		Global.hud.say("Damit, its not a liane but a snake !")
	Global.main.getCurrentScene().continueScene()
	pass
