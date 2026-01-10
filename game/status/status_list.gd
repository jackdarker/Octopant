class_name StatusList extends Node


# something to store Status
# { health: 25, healthMax: 50}

var items:Dictionary={}	# using dictionary, might be faster then array

func addItem(item: Status):	
	items[item.key]=item

func addItemID(itemID:String):
	var newItem = GlobalRegistry.createStat(itemID)
	if(newItem == null):
		return false
	addItem(newItem)
	return true

func removeItem(item:Status):
	if(items.has(item)):
		items.erase(item)

func removeItemID(itemID:String):
	var _item=getItemByID(itemID)
	if(_item):
		removeItem(_item)

func hasItem(item):
	return items.has(item)

func hasItemID(itemID: String):
	for item in items.keys():
		if(items[item].key == itemID):
			return true
	return false

func getItems():
	return items

func getItemByID(itemID)->Status:
	for item in items.keys():
		if(items[item].key == itemID):
			return items[item]
	return null

func registerSignalStatChanged(callable:Callable,Stat:String):
	var item=getItemByID(Stat)
	if item:
		item.changed.connect(callable)

func unregisterSignalStatChanged(callable:Callable,Stat:String):
	var item=getItemByID(Stat)
	if item:
		if item.changed.is_connected(callable):
			item.changed.disconnect(callable)

func loadData(data):
	for item in data["items"]:
		var _item=Status.new()
		_item.loadData(item)
		addItem(_item)
	pass
			
			
func saveData()->Variant:
	var _itemArray:Array = []
	for item in items.keys():
		_itemArray.push_back(items[item].saveData())
	return({"items":_itemArray})
