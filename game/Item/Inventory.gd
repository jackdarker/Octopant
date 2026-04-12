class_name Inventory extends Node

# something to store items in

signal item_added(ID:String)
signal item_removed(ID:String)

var items:Array[ItemBase]=[]
var wrefCharacter:WeakRef=null
var user:Character:
	set(value):
		wrefCharacter=weakref(value)
	get:
		return(wrefCharacter.get_ref())
# set item.amount if you want add multiple items
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
	item_added.emit(item.ID)

func addItemID(itemID:String):
	var newItem = GR.createItem(itemID)
	if(newItem == null):
		return false
	addItem(newItem)
	return true

func removeItem(item:ItemBase,_amount:int=1):
	if(items.has(item)):
		item.amount-=_amount
		if item.amount<=0:
			items.erase(item)
			item.wrefInventory = null
	item_removed.emit(item.ID)

func removeItemID(itemID:String,_amount:int=1):
	var _item=getItemByID(itemID)
	if(_item):
		removeItem(_item,_amount)

#func hasItem(item):
#	return items.has(item)

## returns amount
func hasItemID(itemID: String):
	for item in items:
		if(item.ID == itemID):
			return item.amount
	return 0

func getItems():
	return items

func getItemByID(itemID)->ItemBase:
	for item in items:
		if(item.ID == itemID):
			return item
	return null

static func filter_by_tag(items:Array[ItemBase],tags:Array)->Array:
	var _ret=[] 
	for item in items:
		if item.hasTags(tags):
			_ret.push_back(item)
	return _ret

func loadData(data):
	for item in data["items"]:
		var _item=GR.createItem(item["ID"])
		_item.loadData(item)
		addItem(_item)
	pass
			
			
func saveData()->Variant:
	var _itemArray:Array = []
	for item in items:
		_itemArray.push_back(item.saveData())
	return({"items":_itemArray})
