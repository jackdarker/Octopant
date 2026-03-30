@abstract class_name Recipe extends Object

## recipe specifies how an item can be crafted by the player
# required items
# required skills
# required tools/craftstation	smelter, alembic, stove, brewery
# required time 

#override this
func getTags()->Array:
	return []
	
#override this
func getID()->String:
	return "unknown"

#override this
func getItemID()->String:
	return "unknown"

#override this
func getName()->String:
	return "unknown"

#override this
## description should also give requirements
func getDescription()->String:
	return "unknown"

func getCraftDescription(character:Character)->String:
	var _res:Result=CondCheck.create(getCheck()).check(character)
	var text:=getDescription()
	if(!_res.OK):
		text+="\nmissing requirements"
	text+=_res.Msg
	return text

#override this
func getInventoryImage():
	return "res://assets/images/icons/ic_unknown.svg"

#override this
@abstract func getCheck()->Array[CondCheck.Cond_Base]

func craftItem(character:Character):
	var _check=CondCheck.new()
	_check.addCond(self.getCheck())
	var _res=_check.check(character)
	if(_res.OK):
		_check.check(character,true)
		var _item=GR.createItem(self.getItemID())
		_item.amount=self.amount
		character.inventory.addItem(_item)
		_res.Msg="crafted "+str(_item.amount)+"x "+_item.getName()
	else:
		_res.Msg="cant craft this"		
	return _res

func hasTags(_tags:Array)->bool:
	var _res=true
	var tags=getTags()
	for tag in _tags:
		_res=_res && tags.has(tag)
	return(_res);
