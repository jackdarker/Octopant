extends Node
class_name Inventory

# something to store items in

var items:Array[ItemBase]=[]

func addItem(item: ItemBase):
	if(item.currentInventory != null):
		assert(false)
	
	if(item.canCombine()):
		for myitem in items:
			if(myitem.id == item.id):
				if(myitem.tryCombine(item)):
					#item.queue_free()
					return
		
	items.append(item)
	item.currentInventory = self

func addItemID(itemID:String):
	var newItem = GlobalRegistry.createItem(itemID)
	if(newItem == null):
		return false
	addItem(newItem)
	return true

func removeItem(item):
	if(items.has(item)):
		items.erase(item)
		item.currentInventory = null
		return item
	return null

func hasItem(item):
	return items.has(item)

func hasItemID(itemID: String):
	for item in items:
		if(item.id == itemID):
			return true
	return false

func getItems():
	return items

func getItemByID(itemID)->ItemBase:
	for item in items:
		if(item.id == itemID):
			return item
	return null

func loadData(data):
	for item in data["items"]:
		var _item=GlobalRegistry.createItem(item["ID"])
		_item.loadData(item)
		addItem(_item)
	pass
			
			
func saveData()->Variant:
	var _itemArray:Array = []
	for item in items:
		_itemArray.push_back(item.saveData())
	return({"items":_itemArray})
