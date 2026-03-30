class_name CondCheck extends RefCounted

# Cond_Check takes a number of conditions and checks them against a target
# the check returns pass/fail and a descriptive text
# if the check passes it allows to call execute to impede the constraint to the target, f.e. resource -change
@abstract class Cond_Base extends RefCounted:
	pass
	
#region conditions			#todo Skillcheck, Timecheck, Flagcheck, OnceADayCheck
## check for Resource in inventory
class Cond_Resource extends Cond_Base:
	var resourceName:String
	var resourceCount:int
	static func create(_resource:String,_count:int):
		var me=Cond_Resource.new()
		me.resourceName=_resource
		me.resourceCount=_count
		return me

	func check(target:Character)->Result:
		var _res
		var count=target.inventory.hasItemID(resourceName)
		if count>=resourceCount:
			_res=Result.create(true, "requires "+str(resourceCount)+" "+resourceName)
		else:
			_res=Result.create(false, "requires "+str(resourceCount)+" "+resourceName)
		return _res
	
	func apply(target:Character):
		target.inventory.removeItemID(resourceName,resourceCount)

## check for Stat in range (no stat change)
class Cond_Stat extends Cond_Base:
	var statID:String
	var minValue:float=NAN
	var maxValue:float=NAN
	static func create(_statID:String,_minValue:float,_maxValue:float=NAN):
		var me=Cond_Stat.new()
		me.statID=_statID
		me.minValue=_minValue
		me.maxValue=_maxValue
		return me

	func check(target:Character)->Result:
		var _res=Result.create(true,"")
		var item=target.status.getItemByID(statID)
		if !item:
			return Result.create(false,target.name+"has no "+statID)
		
		if (minValue!=NAN):
			_res.Msg="requires "+statID+" >"+str(minValue)
			if(item.value<minValue):
				_res.OK=false
		if (maxValue!=NAN):
			_res.Msg="requires "+statID+" <"+str(maxValue)
			if(item.value>maxValue):
				_res.OK=false
		if (minValue!=NAN && maxValue!=NAN):
			_res.Msg="requires "+str(minValue)+" <"+statID+" <"+str(maxValue)
		return _res
	
	func apply(target:Character):
		pass

## check for Stat and alter it (positive change means increase of stat)
## returns fail if the stat would change beyond limit
class Cond_StatChange extends Cond_Base:
	var statID:String
	var change:float
	
	static func create(_statID:String,_change:float):
		var me=Cond_StatChange.new()
		me.statID=_statID
		me.change=_change
		return me

	func check(target:Character)->Result:
		var _res=Result.create(true,"")
		var item=target.status.getItemByID(statID)
		if !item:
			return Result.create(false,target.name+"has no "+statID)
		if(item.ll>(item.value+change) || (item.value+change)>item.ul):
			_res.OK=false
		if change>=0:
			_res.Msg="+"
		_res.Msg+=str(change)+" "+statID
		return _res
	
	func apply(target:Character):
		target.status.getItemByID(statID).modify(change)

#endregion
################################################################################
## factory method
static func create(conds:Array[Cond_Base])->CondCheck:
	var me=CondCheck.new()
	me.addCond(conds)
	return me
################################################################################
var conds:Array=[]

func _init():
	pass

func addCond(_conds):
	conds=_conds

#target is character
func check(target, apply=false)->Result:
	var _res=Result.create(true,"")
	for cond in conds:
		_res=_res.And(cond.check(target))
	
	if(apply && _res.OK):
		for cond in conds:
			cond.apply(target)
	
	return _res

#TODO: load&save??
