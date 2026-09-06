class_name Status extends Node

# Character value

signal changed(ID:String,value:float)

static func create(_ID:StringName,_value:float,_ll:float,_ul:float)->Status:
	assert(_ul>_ll)
	var _n=Status.new()
	_n.ID=_ID
	_n.base=_value
	_n.value=_value
	_n.ll_base=_ll
	_n.ul_base=_ul
	_n.ll=_ll
	_n.ul=_ul
	return _n

var ID:String="UNKNOWN"
var wrefList:WeakRef
var parent:StatusList:
	set(value):
		wrefList=weakref(value)
	get:
		return(wrefList.get_ref())
var modifys=[]	#{ID:"Health"} 
var modifier=[]	#{ID:"SuperPotion" bonus:5.0 lmax:20} 
var limits=[]
var base:float=0
var value:float=0	#do not set this!
## sets/gets value related to limits
var value_percent:float:	# 50% -> 50
	set(v):
		if(v>=0):
			value = min(ul,max(ll,v*ul/100.0))
		else:
			value = min(ul,max(ll,v*ll/-100.0))
		changed.emit(ID,value)
	get():
		# ll	v	ul	perc
		# 0		20	60	33
		# -30	6	60	10
		# -30	-15	30	-50
		# 20	30	40	50	or 75 ??	#TODO
		# -50	-20	-10	-25	or -45??
		if(value>=0):
			return (100.0*value/ul)
		else:
			return (-100.0*value/ll)

var ll_base:float=-100
var ul_base:float=100	
var ll:float= -100	#lower limit
var ul:float= 100	#upper limit
var atUL:bool:
	set(value):
		pass
	get:
		return(value>=ul)

var atLL:bool:
	set(value):
		pass
	get:
		return(value<=ll)

## modifys value by change
# args["ul"] or args["ll"] = limit change up to this upper/lower limit
func modify(change:float, _args:={}):
	var _ul=min(ul,_args["ul"] if _args.has("ul") else ul)
	var _ll=max(ll,_args["ll"] if _args.has("ll") else ll)
	if(change>=0):
		value=min(_ul,(value+change))
	else:
		value=max(_ll,value+change)
	changed.emit(ID,value)


## this is called to update value of the stat and will trigger calculation of dependend stats; 
## requires that the all stats were added to the dictionary before! 
func calc( ):
	var _min=ll_base
	var _max=ul_base
	# recalculate modifiers
	var _old = value
	var _new = base  
	for mod:Dictionary in modifier:
		if(mod.has("bonus")):
			_new += mod.bonus
		if(mod.has("lmin")):
			_min= max(mod.lmin,_min)
		if(mod.has("lmax")):
			_max= min(mod.lmax,_max)
	_new = max(_min,min(_max,_new));
	ul=_max
	ll=_min
	value = _new;
	#msg+=this.formatMsgStatChange(attr,_new,_old);//todo no log hidden
	updateModifier();
	#trigger recalculation of dependend Stats
	for mod in modifys:
		parent.getItemByID(mod).calc()

# override this if you want this Stat to add a modifier to another stat
func updateModifier():
	pass

func loadData(data):
	ID=data["ID"]
	base=data["base"]		
	ll_base=data["ll"]
	ul_base=data["ul"]
	modifier=data["modifier"]
	modifys=data["modifys"]
			
func saveData()->Variant:
	return({"ID":ID,"base":base,"ll":ll_base,"ul":ul_base,"modifys":modifys,"modifier":modifier})
