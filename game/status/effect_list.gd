class_name EffectsList extends Node

# see also UI/ui_effect_list for the widget

# something to store Status-Effects
# { "bleeding":Object}

var items:Dictionary={}	# using dictionary, might be faster then array
var changedCB:Array[Callable]=[]

# use effect.applyTo(target) instead !
func addItem(item: Effect):
	var _item=getItemByID(item.ID)
	if _item:
		for cb in changedCB:
			unregisterSignalItemChanged(cb,item.ID)	#combine might create new item
		items[item.ID]=_item.combine(item)
	else:
		items[item.ID]=item
	
	for cb in changedCB:
		registerSignalItemChanged(cb,item.ID)

func addItemID(itemID:String):
	var newItem = GlobalRegistry.createEffect(itemID)
	if(newItem == null):
		return false
	addItem(newItem)
	return true

func removeItem(item:Effect):
	if(items.has(item.ID)):
		items.erase(item.ID)
		item.destroyMe()

func removeItemID(itemID:String):
	var _item=getItemByID(itemID)
	if(_item):
		_item.removeItem()

func hasItem(item:Effect):
	return items.has(item.ID)

func hasItemID(itemID: String):
	for item in items.keys():
		if(items[item].ID == itemID):
			return true
	return false

func getItems():
	return items.values()

func getItemByID(itemID)->Effect:
	for item in items.keys():
		if(items[item].ID == itemID):
			return items[item]
	return null


# register callback when item is modified - this only works for items already in the list!
func registerSignalItemChanged(callable:Callable,ID:String):
	var item=getItemByID(ID)
	if item:
		if !item.changed.is_connected(callable):
			item.changed.connect(callable)

#register callback for any item, also for newly added
func registerSignalItemsChanged(callable:Callable):
	for item in getItems():
		if !item.changed.is_connected(callable):
			item.changed.connect(callable)
	if !changedCB.has(callable):
		changedCB.push_back(callable)


func unregisterSignalItemChanged(callable:Callable,ID:String):
	var item=getItemByID(ID)
	if item:
		if item.changed.is_connected(callable):
			item.changed.disconnect(callable)

func unregisterSignalItemsChanged(callable:Callable):
	for item in getItems():
		if item.changed.is_connected(callable):
			item.changed.disconnect(callable)
	changedCB.erase(callable)


func loadData(data):
	for item in data["items"]:
		var _item=GlobalRegistry.createEffect(item["ID"])
		_item.loadData(item)
		addItem(_item)
			
			
func saveData()->Variant:
	#TODO save changedCB?
	var _itemArray:Array = []
	for item in items.keys():
		_itemArray.push_back(items[item].saveData())
	return({"items":_itemArray})
