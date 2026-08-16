class_name LootTableEntry extends Resource
@export var price:float
@export var ID:String

static func create(_price:float,_ID:String)->LootTableEntry:
	var _x=LootTableEntry.new()
	_x.price=_price
	_x.ID=_ID
	return(_x)
