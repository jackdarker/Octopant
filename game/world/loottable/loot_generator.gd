class_name LootGenerator extends RefCounted

## there can be one list for each tier. If there is no list for a tier, the lesser one is used and if there is none, no loot is generated. 

## new-price = base-price^tier
static func scalePriceByTier(price:float,_tier:int=1)->float:
	return pow(price,_tier)

## wealth is a goal-price of all items, it scales with tier 
static func generateItems(ID:String,_wealth:float, tier:int)->Array[ItemBase]:
	var wealth=scalePriceByTier(_wealth,tier)
	var _items:Array[ItemBase]=[]
	var _item:LootTableEntry
	var table=GR.getLoottable(ID,tier).table
	while(table.size()>0):
		table=table.filter(func(x): return x.price<=wealth)
		#pick some random item from items less worth then wealth,
		_item=Util.pickRandomFromArray(table)
		if(!_item):
			break
		#reduce wealth by the price of the item
		wealth-=_item.price
		_items.push_back(GR.createItem(_item.ID)) 
		#repeat until there is no more item affordable
		
		#if there was nothing found, try again with tier-1 
	return _items
