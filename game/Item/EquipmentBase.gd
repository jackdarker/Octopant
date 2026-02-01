class_name EquipmentBase extends ItemBase

# see BodySlotEnum
var slotUse:Array[int] = []	#which slot is used by the equip
var slotCover:Array[int] = []  #which other slots are invisible by this "uses Breast, covers bBreast,bNipples"
var equipped:bool=false
var durability:float=-2	#in %; -2= unbreakable

func getPossibleActions():
	if equipped:
		return [ 
			{	"name": "unequip",
				"description": "unequip",
			}]
	else:
		return [ 
			{	"name": "equip",
				"description": "equip",
			}]
		
func canDo(action,target)->Result:
	if(action=="equip"):
		return canEquip(target)
	elif(action=="unequip"):
		return canUnequip()
	else:
		return (Result.create(false,""))

func doAction(action:String,target):
	if(action=="equip"):
		if target is Character:
			target.outfit.addItem(self)
	if(action=="unequip"):
		if target is Character:
			target.outfit.removeItem(self.getID())	


func isEquipped()->bool:
	return equipped

func canEquip(_target:Character)->Result:
	return Result.create(true,"")

func canUnequip()->Result:
	return Result.create(true,"")

# use outfit.addItem instead !
func equip(target:Character)->Result:
	var _res=Result.create(true,"")
	wrefCharacter = weakref(target)
	equipped=true
	return _res
	
	#or (n of this.bonus){
	#        n.onEquip();
	#   }
	 # if(this.equipText) res.msg=this.equipText(context);


# use outfit.removeItem instead !
func unequip()->Result:
	wrefCharacter=null
	equipped=false
	return Result.create(true,"")

#in %
func getDurability()->float:
	return durability

func modifyDurability(value:float):
	if(durability>-2):
		durability=max(0,durability+value)
