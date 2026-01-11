class_name EffectsList extends Node


# something to store Status-Effects
# { "bleeding":Object}

var items:Dictionary={}	# using dictionary, might be faster then array

func addItem(item: Effect):
	var _item=getItemByID(item.ID)
	if _item:
		items[item.ID].combine(item)
	else:
		items[item.ID]=item

func addItemID(itemID:String):
	var newItem = GlobalRegistry.createEffect(itemID)
	if(newItem == null):
		return false
	addItem(newItem)
	return true

func removeItem(item:Effect):
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
		if(items[item].ID == itemID):
			return true
	return false

func getItems():
	return items

func getItemByID(itemID)->Status:
	for item in items.keys():
		if(items[item].ID == itemID):
			return items[item]
	return null

func loadData(data):
	for item in data["items"]:
		var _item=GlobalRegistry.createEffect(item["ID"])
		_item.loadData(item)
		addItem(_item)
			
			
func saveData()->Variant:
	var _itemArray:Array = []
	for item in items.keys():
		_itemArray.push_back(items[item].saveData())
	return({"items":_itemArray})
