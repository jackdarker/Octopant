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
		pass#assert(false)
	
	var _item2=getItemByID(item.ID)
	if(item.canStack() && _item2):
		_item2.tryCombine(item)
	else:
		items.append(item)
		item.wrefInventory = weakref(self)
		item.user=user
	item_added.emit(item.ID)

func addItemID(itemID:String):
	var newItem = GR.createItem(itemID)
	if(newItem == null):
		return 
	addItem(newItem)

func removeItem(item:ItemBase,_amount:int=1, _no_destroy:bool=false):
	if(items.has(item)):
		var _new_amount=item.amount-_amount
		if _new_amount<=0:
			items.erase(item)
			if(_no_destroy):
				item.wrefInventory=null
			else:	
				item.destroyMe()
			#item.wrefInventory = null
		else:
			item.amount-=_amount
		item_removed.emit(item.ID)

func removeItemID(itemID:String,_amount:int=1):
	var _item=getItemByID(itemID)
	if(_item):
		removeItem(_item,_amount)

#func hasItem(item):
#	return items.has(item)

## returns amount
func hasItemID(itemID: String)->int:
	for item in items:
		if(item.ID == itemID):
			return item.amount
	return 0

func getItems()->Array[ItemBase]:
	return items

func getItemByID(itemID)->ItemBase:
	for item in items:
		if(item.ID == itemID):
			return item
	return null

## returns only items that have all the tags
static func filter_by_tag(allItems:Array,tags:Array)->Array:
	var _ret=[] 
	for item in allItems:
		if item.hasAllTags(tags):
			_ret.push_back(item)
	return _ret

func loadData(data):
	items.clear()
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
