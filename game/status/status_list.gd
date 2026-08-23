class_name StatusList extends Node


# something to store Status
# { health: 25, healthMax: 50}

var items:Dictionary={}	# using dictionary, might be faster then array

func addItem(item: Status):
	item.parent=self
	items[item.ID]=item
	item.calc()

func addItemID(itemID:String):
	var newItem = GR.createStat(itemID)
	if(newItem == null):
		return false
	addItem(newItem)
	return true

func removeItem(item:Status):
	if(items.has(item.ID)):
		items.erase(item.ID)

func removeItemID(itemID:String):
	var _item=getItemByID(itemID)
	if(_item):
		removeItem(_item)

func hasItem(item:Status):
	return items.has(item.ID)

func hasItemID(itemID: String):
	for item in items.keys():
		if(items[item].ID == itemID):
			return true
	return false

func getItems():
	return items.values()

func getItemByID(itemID)->Status:
	for item in items.keys():
		if(items[item].ID == itemID):
			return items[item]
	return null

## modifiers can be added to change value or limit of a stat; f.e caused by Effect
## see also Status.updateModifier
## addModifier("Strength",{ID:"SuperPotion" bonus:5.0 lmin:0 lmax:20}) 
## use removeModifier to remove the modifier
func addModifier(toId:String,modData:Dictionary):
	var _stat = getItemByID(toId)
	var _oldMods:Array = _stat.modifier
	var _x:int=-1
	for i in range(_oldMods.size()):
		if(_oldMods[i].ID==modData.ID):
			_x=i
	if(_x>=0):
		_oldMods.remove_at(_x)
	_oldMods.push_back(modData);
	#window.gm.pushLog(
	_stat.calc()

func removeModifier(toId,modData):
	var _stat = getItemByID(toId);
	var _oldMods:Array = _stat.modifier;
	var _x:int=-1;
	for i in range(_oldMods.size()):
		if(_oldMods[i].ID==modData.ID):
			_x=i

	if(_x>=0):
		_oldMods.remove_at(_x)
	#window.gm.pushLog(
	_stat.calc()

# register callback when stat is modified
func registerSignalItemChanged(callable:Callable,ID:String):
	var item=getItemByID(ID)
	if item:
		if !item.changed.is_connected(callable):
			item.changed.connect(callable)

func unregisterSignalItemChanged(callable:Callable,ID:String):
	var item=getItemByID(ID)
	if item:
		if item.changed.is_connected(callable):
			item.changed.disconnect(callable)

func loadData(data):
	items.clear()
	for item in data["items"]:
		var _item=GR.createStat(item.ID)
		_item.loadData(item)
		addItem(_item)
	for item in items.values():
		item.calc()
			
			
func saveData()->Variant:
	var _itemArray:Array = []
	for item in items.keys():
		_itemArray.push_back(items[item].saveData())
	return({"items":_itemArray})
