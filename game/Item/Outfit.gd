class_name Outfit extends Node

# equipped clothing and weapons

var list:Array=[]	#[{item:x, slots:['Legs']}]
var slots:Array[int]=[]	#see BodySlotEnum
var wrefCharacter:WeakRef=null

func getAllIds()->Array:
	return(list.map(func(x):return(x.item.ID)))

func getItems()->Array:
	return(list.map(func(x):return(x.item)))

func getItem(ID:String)->EquipmentBase:
	for n in list:
		if(n.item.ID==ID):
			return(n.item)
	
	return(null)

#detect which slots are used by a item
func getItemSlots(ID:String)->Array[int]:
	for n in list:
		if(n.item.ID==ID):
			return(n.slots)
	
	return([])

func getItemIdForSlot(slot:int)->String:
	for n in list:
		if(n.slots.has(slot)):
			return(n.item.ID)
	
	return("")
	
func getItemForSlot(slot:int)->EquipmentBase:
	for n in list:
		if(n.slots.has(slot)):
			return(n.item)
	
	return(null)

func canUnequipItem(ID)->Result:
	var _idx = getItemSlots(ID)
	var _item = getItem(ID)
	var result = _item.canUnequip()
	#for _slot in _idx:
	#	var _tmp = canUnequipSlot(_slot)	TODO
	#	if(!_tmp.OK): 
	#		result.msg +=_tmp.msg+" "
	#	result.OK = result.OK && _tmp.OK;
	
	return(result);

#trys to add equipment
func addItem(item:EquipmentBase)->Result:		#TODO force:bool=false?
	var result = Result.create(true,"")
	var _idx:Array[int] = getItemSlots(item.ID)
	if(_idx.size()>0):
		return(result)	#already equipped

	_idx = item.slotUse
	var _oldIDs:Array = []
	var _oldItem:EquipmentBase
	var _oldSlots:Array = []
	#check if equipment is equipable
	#TODO	result = this.canEquipSlot(_idx);                // check if slot is available for equip this
	if(result.OK):
		result = item.canEquip(wrefCharacter.get_ref())
	if(result.OK):
		for _slot in _idx:#check if the current equip can be unequipped
			var oldId = getItemIdForSlot(_slot)
			if(oldId==""):
				continue
			if(_oldIDs.find(oldId)<0):
				_oldIDs.push_back(oldId)
				_oldSlots.append_array(getItem(oldId).slotUse)
				var _tmp = canUnequipItem(oldId)
				if(!_tmp.OK):
					result.msg += _tmp.msg #TODO duplicated msg if item uses multiple slots 
					result.OK = result.OK && _tmp.OK
	if(!result.OK):
		#TODO this.postItemChange(_item.name,"equip_fail:",result.msg);
		return(result)
	
	#auto-unequip worn items	
	for _ID in _oldIDs:
		removeItem(_ID)
		
	var _item=item
	#if item is from wardrobe/Inventory, remove it there
	if(item.currentInventory):
		item.currentInventory.removeItem(item);
		_item=item.duplicate()	#you might have multiple helmets in inventory, we need a separate instance	
	#Todo currently we have 2 copies of equipment - 1 for wardrobe 1 for outfit otherwise this will not work
	list.push_back({"item":_item, "slots":_item.slotUse})
	result=_item.equip(wrefCharacter.get_ref());
	#this.postItemChange(_item.name,"equipped",""/*result.msg*/);
	return(result)


func removeItem(ID:String, _force:bool=false)->Result:
	var result =Result.create(true,"")
	var _allIds=getAllIds();
	if(!_allIds.has(ID)):
			return(result)	#already unequipped
	#TODO result =(force)?result:this.canUnequipItem(ID);
	if(!result.OK):
		#this.postItemChange(ID,"unequip_fail",result.msg);
		return(result);
	var _idx=_allIds.find(ID)
	var _item = list[_idx].item
	result=_item.unequip()
	list.remove_at(_idx)
	#unequipped items go into wardrobe except bodyparts
	if(_item.hasTags([ItemTagEnum.Body])):
		pass# store bodyparts 
	#elif(_item.hasTag(.Weapon)){
		#this.parent.Inv.addItem(_item);
	else:
		#this.parent.Wardrobe.addItem(_item)
		wrefCharacter.get_ref().inventory.addItem(_item)
	#this.postItemChange(ID,"removed",""/*result.msg*/);
	#Todo delete _item;    //un-parent
	return(result)
   
#region load/save
func loadData(data):
	for slot in data["slots"]:
		slots.push_back(slot)
		
	for item in data["items"]:
		var _item=GlobalRegistry.createItem(item["ID"])
		_item.loadData(item)
		_item.wrefCharacter=wrefCharacter
		list.push_back({"item":_item,"slots":_item.slotUse})	#using addItem would retrigger equip()
	pass
			
			
func saveData()->Variant:
	var _itemArray:Array = []
	for item in list:
		_itemArray.push_back(item.item.saveData())	#slots is not safed and will be restored
	return({"items":_itemArray,"slots":slots})
#endregion
