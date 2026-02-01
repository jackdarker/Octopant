class_name Inventory extends Node

# something to store items in

var items:Array[ItemBase]=[]
var wrefCharacter:WeakRef=null
var user:Character:
	set(value):
		wrefCharacter=weakref(value)
	get:
		return(wrefCharacter.get_ref())

func addItem(item: ItemBase):
	if(item.wrefInventory != null):
		assert(false)
	
	if(item.canCombine()):
		for myitem in items:
			if(myitem.ID == item.ID):
				if(myitem.tryCombine(item)):
					#item.queue_free()
					return
		
	items.append(item)
	item.wrefInventory = weakref(self)
	item.user=user

func addItemID(itemID:String):
	var newItem = GlobalRegistry.createItem(itemID)
	if(newItem == null):
		return false
	addItem(newItem)
	return true

func removeItem(item:ItemBase):
	if(items.has(item)):
		if item.amount>1:
			item.amount-=1
		else:
			items.erase(item)
			item.wrefInventory = null

func removeItemID(itemID:String):
	var _item=getItemByID(itemID)
	if(_item):
		removeItem(_item)

func hasItem(item):
	return items.has(item)

func hasItemID(itemID: String):
	for item in items:
		if(item.ID == itemID):
			return true
	return false

func getItems():
	return items

func getItemByID(itemID)->ItemBase:
	for item in items:
		if(item.ID == itemID):
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
